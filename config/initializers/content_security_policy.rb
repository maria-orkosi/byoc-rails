# Content Security Policy for analytics scripts.
# Nonce-based CSP allows inline scripts that carry a matching nonce.
Rails.application.config.content_security_policy do |policy|
  policy.script_src  :self, :https, :unsafe_inline
  policy.style_src   :self, :https, :unsafe_inline
  policy.connect_src :self, :https
  policy.img_src     :self, :https, :data
  policy.font_src    :self, :https
end

# Enable the nonce generator for inline scripts and styles.
Rails.application.config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
Rails.application.config.content_security_policy_nonce_directives = %w[script-src style-src]