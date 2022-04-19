class AuthFailureApp < Devise::FailureApp

  protected

  def http_auth_body
    return super unless request_format == :jsonapi

    {
      errors: [
        {
          title: I18n.t('api.errors.not_authorized_title'),
          detail: i18n_message,
          source: {
            pointer: ''
          }
        }
      ],
      jsonapi: {
        version: '1.0'
      }
    }.to_json
  end
end
