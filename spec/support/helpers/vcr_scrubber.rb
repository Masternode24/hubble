module VcrScrubber
  REPLACE_WITH = 'REDACTED'.freeze

  # Allowed by default
  KEEP = [
    /^http/,
    /localhost/
  ].freeze

  # Never allow
  FORCE_REMOVE = [
    /slack/
  ].freeze

  def self.configure(config, secrets)
    secret_values = secrets.
      map { |_, val| val.is_a?(Hash) ? val.values : val }.
      flatten.
      select(&:present?).
      reject { |val| has_matches?(KEEP, val) && !has_matches?(FORCE_REMOVE, val) }

    secret_values.each do |val|
      config.filter_sensitive_data(REPLACE_WITH) { val }
    end
  end

  def self.has_matches?(list, val)
    list.count { |pattern| pattern.match(val) } > 0
  end
end
