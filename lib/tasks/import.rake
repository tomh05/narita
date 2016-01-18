require 'fileutils'
namespace :coot do
  desc "Import all ciphertexts"
  task :import_ciphertexts => :environment do
    Dir.mkdir("/var/lib/data-diode/received/imported") unless File.exists?("/var/lib/data-diode/received/imported")
    Dir.glob("/var/lib/data-diode/received/*.txt.gpg").each do |path| #TODO add image processing
      begin
        # Parse filename
        filename = File.basename(path)
        username = filename.match(/^.+?\.(.+)_.+?.txt.gpg/)[1]
        type = filename.match(/^.+?\..+_(.+?).txt.gpg/)[1]
        # Decrypt
        `/bin/decryptor #{path}`
        cleartext_path = path.gsub('received', 'cleartext').gsub('.gpg', '')
        # Load cleartext
        content = File.read(cleartext_path)
        # Strip GPG signature block
        content.gsub!(/^(-----BEGIN PGP MESSAGE-----.+-----END PGP MESSAGE-----$?)/m,'')
        # Import content
        case type
        when "app"
          AppUnique.import(content)
        when "appsummary"
          App.import(content)
        when "backup"
          Backup.import(content)
        when "call"
          Call.import(content)
        when "location"
          Location.import(content)
        when "screen"
          Screen.import(content)
        when "sim"
          Sim.import(content)
        when "fb"
          FacebookMessage.import(content)
        end
        # Clean up the cleartext - only keep the ciphertexts around
        `shred -u -z #{cleartext_path}`
        # Move this file elsewhere so we don't re-import it
        FileUtils.mv(path, path.gsub("/received/","/received/imported/"))
      rescue => e
        puts "Failed to import data from #{path}: #{e.inspect}\n#{e.backtrace}"
      end
    end
  end
end
