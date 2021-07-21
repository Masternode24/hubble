module DownloadHelpers
  TIMEOUT = 10
  PATH    = Rails.root.join('')

  class << self
    def downloads
      Dir[PATH.join('*')]
    end

    def download(file)
      downloads.select { |d| d.include?(file) }.first
    end

    def download_content(file)
      wait_for_download
      File.read(download(file))
    end

    def wait_for_download
      Timeout.timeout(TIMEOUT) do
        sleep 0.1 until downloaded?
      end
      sleep 0.1
    end

    def downloaded?
      downloads.any? && !downloading?
    end

    def downloading?
      downloads.grep(/\.part$/).any?
    end

    def clear_downloads(file)
      FileUtils.rm_f(download(file))
    end
  end
end
