require 'rails_helper'

RSpec.describe "Schedules", type: :request do
  let!(:rooms) { create_list(:room, 2) }
  let!(:user) { create(:user) }

  describe "GET /schedules" do
    let(:perform) { get '/schedules', headers: headers }

    context 'when the access token is empty' do
      let(:headers) { { } }

      it 'returns not authorized' do
        perform

        expect(response.status).to eq(401)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'Not Authorized'
          }
        }.to_json)
      end
    end

    context 'when access token is valid' do
      let(:headers) { valid_authorization_header }

      context 'when there is not schedule' do
        let(:expected) { { data: { rooms: [] } }.to_json }

        it "returns an empty array" do
          perform

          expect(response.body).to eq(expected)
        end
      end

      context 'when there are schedules for only one room' do
        let!(:first_room_schedule) { create(:schedule, user: user, room: rooms.first) }
        let!(:last_room_schedules) { create_list(:schedule, 2, user: user, room: rooms.last) }
        let(:expected) do
          {
            data: {
              rooms: [
                {
                  rooms.first.name => [
                    {
                      start_time: first_room_schedule.start_time.strftime('%Y-%m-%d %H:%M:%S'),
                      end_time: first_room_schedule.end_time.strftime('%Y-%m-%d %H:%M:%S'),
                    }
                  ]
                },
                {
                  rooms.last.name => last_room_schedules.map do |schedule|
                    {
                      start_time: schedule.start_time.strftime('%Y-%m-%d %H:%M:%S'),
                      end_time: schedule.end_time.strftime('%Y-%m-%d %H:%M:%S'),
                    }
                  end
                }
              ]
            }
          }.to_json
        end

        it 'returns the schedules for only one room' do
          perform

          expect(response.body).to eq(expected)
        end
      end

      context 'when there are schedules for more than one room' do
      end
    end
  end

  describe "POST /schedules" do
    let(:perform) { post '/schedules', params: params, headers: headers }

    context 'when the access token is empty' do
      let(:headers) { {} }
      let(:params) { {} }

      it 'returns not authorized' do
        perform

        expect(response.status).to eq(401)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'Not Authorized'
          }
        }.to_json)
      end
    end

    context 'when access token is valid' do
      let(:headers) { valid_authorization_header }

      context 'when user\'s email is empty' do
        let(:params) { { room_name: rooms.first.name } }

        it 'returns bad request' do
          perform

          expect(response.status).to eq(400)
        end

        it 'returns the error message' do
          perform

          expect(response.body).to eq({
            error: {
              message: 'user_email must not be empty'
            }
          }.to_json)
        end
      end

      context 'when room_name is empty' do
        let(:params) { { user_email: user.email } }

        it 'returns bad request' do
          perform

          expect(response.status).to eq(400)
        end

        it 'returns the error message' do
          perform

          expect(response.body).to eq({
            error: {
              message: 'room_name must not be empty'
            }
          }.to_json)
        end
      end

      context 'when schedule is empty' do
        let(:params) do
          {
            user_email: user.email,
            room_name: rooms.first.name,
          }
        end

        it 'returns bad request' do
          perform

          expect(response.status).to eq(400)
        end

        it 'returns the error message' do
          perform

          expect(response.body).to eq({
            error: {
              message: 'schedule must not be empty'
            }
          }.to_json)
        end
      end

      context 'when params has all necessary fields' do
        let(:params) do
          {
            user_email: user.email,
            room_name: rooms.first.name,
            schedule: schedule_params
          }
        end

        context 'but schedule has invalid date time format' do
          let(:schedule_params) do
            {
              start_time: 'invalid',
              end_time: DateTime.now.strftime('%Y-%m-%d %H:%M:%S'),
            }
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule must have valid time'
              }
            }.to_json)
          end
        end

        context 'but end_time is lesser than start_time' do
          let(:schedule_params) do
            {
              end_time: 1.day.ago.to_datetime.strftime('%Y-%m-%d %H:%M:%S'),
              start_time: DateTime.now.strftime('%Y-%m-%d %H:%M:%S'),
            }
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule start_time must not be greater than end_time'
              }
            }.to_json)
          end
        end

        context 'but it is trying to schedule out of work hours' do
          let(:schedule_params) do
            {
              start_time: '2021-11-08 05:00:00',
              end_time: DateTime.now.strftime('%Y-%m-%d %H:%M:%S'),
            }
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule must be within work hours'
              }
            }.to_json)
          end
        end

        context 'but it is trying to schedule more than one day' do
          let(:schedule_params) do
            {
              start_time: '2021-11-08 09:00:00',
              end_time: '2021-11-09 10:00:00',
            }
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule must be in the same day'
              }
            }.to_json)
          end
        end

        context 'but start_time conflicts with an existent schedule' do
          let(:start_time) { '2021-11-07T09:00:00'.to_datetime }
          let(:end_time) { '2021-11-07T10:00:00'.to_datetime }
          let(:schedule_params) do
            {
              start_time: '2021-11-07T09:30:00',
              end_time: '2021-11-07T10:30:00',
            }
          end

          let!(:schedule) do
            create(
              :schedule,
              room: rooms.first,
              user: user,
              start_time: start_time,
              end_time: end_time,
            )
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule not available'
              }
            }.to_json)
          end
        end

        context 'but end_time conflicts with an existent schedule' do
          let(:start_time) { '2021-11-07T10:00:00'.to_datetime }
          let(:end_time) { '2021-11-07T11:30:00'.to_datetime }
          let(:schedule_params) do
            {
              start_time: '2021-11-07T09:30:00',
              end_time: '2021-11-07T11:30:00',
            }
          end

          let!(:schedule) do
            create(
              :schedule,
              room: rooms.first,
              user: user,
              start_time: start_time,
              end_time: end_time,
            )
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule not available'
              }
            }.to_json)
          end
        end

        context 'but there are schedules within start_time and end_time' do
          let(:start_time) { '2021-11-07T10:00:00'.to_datetime }
          let(:end_time) { '2021-11-07T12:00:00'.to_datetime }
          let(:schedule_params) do
            {
              start_time: '2021-11-07 09:30:00',
              end_time: '2021-11-07 14:30:00',
            }
          end

          let!(:schedule) do
            create(
              :schedule,
              room: rooms.first,
              user: user,
              start_time: start_time,
              end_time: end_time,
            )
          end

          it 'returns unprocessable entity' do
            perform

            expect(response.status).to eq(422)
          end

          it 'returns the error message' do
            perform

            expect(response.body).to eq({
              error: {
                message: 'Schedule not available'
              }
            }.to_json)
          end
        end

        context 'and the params are valid' do
          let(:start_time) { '2021-11-07T10:00:00'.to_datetime }
          let(:end_time) { '2021-11-07T12:00:00'.to_datetime }
          let(:schedule_params) do
            {
              start_time: '2021-11-07 14:00:00',
              end_time: '2021-11-07 14:30:00',
            }
          end

          let!(:schedule) do
            create(
              :schedule,
              room: rooms.first,
              user: user,
              start_time: start_time,
              end_time: end_time,
            )
          end

          it 'returns created' do
            perform

            expect(response.status).to eq(201)
          end

          it 'returns the schedule' do
            perform

            expect(response.body).to eq({
              data: {
                message: 'success'
              }
            }.to_json)
          end

          it 'creates a schedule' do
            perform

            persisted = Schedule.find_by(
              start_time: schedule_params[:start_time].to_datetime,
              end_time: schedule_params[:end_time].to_datetime,
            )

            expect(persisted).not_to be_nil
          end
        end
      end
    end
  end

  describe "PUT /schedule/:id" do
    let(:perform) { put "/schedules/#{schedule_id}", params: params, headers: headers }

    context 'when the access token is empty' do
      let(:headers) { {} }
      let(:params) { {} }
      let(:schedule_id) { 'whatever' }

      it 'returns not authorized' do
        perform

        expect(response.status).to eq(401)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'Not Authorized'
          }
        }.to_json)
      end
    end

    context 'when access token is valid' do
      let(:headers) { valid_authorization_header }

      context 'when schedule is empty' do
        let(:schedule_id) { 'invalid' }
        let(:params) { {} }

        it 'returns bad request' do
          perform

          expect(response.status).to eq(400)
        end

        it 'returns the error message' do
          perform

          expect(response.body).to eq({
            error: {
              message: 'schedule must not be empty'
            }
          }.to_json)
        end
      end

      context 'when params has all necessary fields' do
        let(:params) do
          {
            schedule: {
              start_time: start_time,
              end_time: end_time
            }
          }
        end

        context 'when schedule does not exist' do
          let(:schedule_id) { 'invalid' }
          let(:start_time) { DateTime.now }
          let(:end_time) { DateTime.now }

          it 'returns not found' do
            perform

            expect(response.status).to eq(404)
          end
        end

        context 'when the schedule exist' do
          let(:schedule)    { create(:schedule) }
          let(:schedule_id) { schedule.id }

          context 'but schedule has invalid date time format' do
            let(:start_time) { 'invalid' }
            let(:end_time)   { 'invalid' }

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule must have valid time'
                }
              }.to_json)
            end
          end

          context 'but end_time is lesser than start_time' do
            let(:start_time) { '2021-11-09 13:00:00' }
            let(:end_time)   { '2021-11-09 12:00:00' }

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule start_time must not be greater than end_time'
                }
              }.to_json)
            end
          end

          context 'but it is trying to schedule out of work hours' do
            let(:start_time) { '2021-11-09 13:00:00' }
            let(:end_time)   { '2021-11-09 20:00:00' }

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule must be within work hours'
                }
              }.to_json)
            end
          end

          context 'but it is trying to schedule more than one day' do
            let(:start_time) { '2021-11-09 13:00:00' }
            let(:end_time)   { '2021-11-10 10:00:00' }

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule must be in the same day'
                }
              }.to_json)
            end
          end

          context 'but start_time conflicts with an existent schedule' do
            let(:start_time) { '2021-11-10T09:00:00'.to_datetime }
            let(:end_time) { '2021-11-10T10:00:00'.to_datetime }

            let!(:schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-07T09:30:00'.to_datetime,
                end_time: '2021-11-10T10:00:00'.to_datetime,
              )
            end

            let!(:another_schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-10T09:00:00'.to_datetime,
                end_time: '2021-11-10T09:30:00'.to_datetime,
              )
            end

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule not available'
                }
              }.to_json)
            end
          end

          context 'but end_time conflicts with an existent schedule' do
            let(:start_time) { '2021-11-10T09:00:00'.to_datetime }
            let(:end_time) { '2021-11-10T13:00:00'.to_datetime }

            let!(:schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-07T09:30:00'.to_datetime,
                end_time: '2021-11-10T10:00:00'.to_datetime,
              )
            end

            let!(:another_schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-10T12:30:00'.to_datetime,
                end_time: '2021-11-10T13:30:00'.to_datetime,
              )
            end

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule not available'
                }
              }.to_json)
            end
          end

          context 'but there are schedules within start_time and end_time' do
            let(:start_time) { '2021-11-10T12:00:00'.to_datetime }
            let(:end_time) { '2021-11-10T18:00:00'.to_datetime }

            let!(:schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-07T09:30:00'.to_datetime,
                end_time: '2021-11-10T10:00:00'.to_datetime,
              )
            end

            let!(:another_schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-10T14:00:00'.to_datetime,
                end_time: '2021-11-10T15:30:00'.to_datetime,
              )
            end

            it 'returns unprocessable entity' do
              perform

              expect(response.status).to eq(422)
            end

            it 'returns the error message' do
              perform

              expect(response.body).to eq({
                error: {
                  message: 'Schedule not available'
                }
              }.to_json)
            end
          end

          context 'and the params are valid' do
            let(:start_time) { '2021-11-11T09:00:00'.to_datetime }
            let(:end_time) { '2021-11-11T10:00:00'.to_datetime }

            let!(:schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-07T09:30:00'.to_datetime,
                end_time: '2021-11-10T10:00:00'.to_datetime,
              )
            end

            let!(:another_schedule) do
              create(
                :schedule,
                room: rooms.first,
                user: user,
                start_time: '2021-11-10T09:00:00'.to_datetime,
                end_time: '2021-11-10T09:30:00'.to_datetime,
              )
            end

            it 'returns created' do
              perform

              expect(response.status).to eq(201)
            end

            it 'returns the schedule' do
              perform

              expect(response.body).to eq({
                data: {
                  message: 'success'
                }
              }.to_json)
            end

            it 'creates a schedule' do
              perform

              schedule.reload

              expect(schedule.start_time).to eq(start_time)
              expect(schedule.end_time).to eq(end_time)
            end
          end
        end
      end
    end

  end

  describe "DELETE /schedule/:id" do
    let(:perform) { delete "/schedules/#{schedule_id}", headers: headers }

    context 'when the access token is empty' do
      let(:headers) { {} }
      let(:schedule_id) { 'whatever' }

      it 'returns not authorized' do
        perform

        expect(response.status).to eq(401)
      end

      it 'returns error message' do
        perform

        expect(response.body).to eq({
          error: {
            message: 'Not Authorized'
          }
        }.to_json)
      end
    end

    context 'when access token is valid' do
      let(:headers) { valid_authorization_header }

      context 'when the schedule does not exist' do
        let(:schedule_id) { 'invalid' }

        it 'returns not found' do
          perform

          expect(response.status).to eq(404)
        end
      end

      context 'when the schedule exists' do
        let(:schedule) { create(:schedule) }
        let(:schedule_id) { schedule.id }

        it 'returns ok' do
          perform

          expect(response.status).to eq(200)
        end

        it 'returns success message' do
          perform

          expect(response.body).to eq({
            data: {
              message: 'success'
            }
          }.to_json)
        end

        it 'deletes the schedule' do
          perform


          expect(Schedule.find_by(id: schedule_id)).to be_nil
        end
      end
    end
  end
end
