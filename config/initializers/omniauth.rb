Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '9isVRy5mq4fyeN1jeeG65w', 'Yag3lZ6gToJTkUmrcZRNmuxcLbVIwUPjkVSdcLOw'
  provider :facebook, "481716485219346", "a0730bf1b4ceb2d0117ace7413fb8a23", :scope => "email, publish_stream, read_stream"
end

