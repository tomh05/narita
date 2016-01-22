require 'fileutils'
namespace :coot do
  desc "Import all ciphertexts"
  task :import_ciphertexts => :environment do
    Dir.mkdir("/var/lib/data-diode/received/imported") unless File.exists?("/var/lib/data-diode/received/imported")
    Dir.glob("/var/lib/data-diode/received/*.gpg").each do |path| #TODO add image processing
      begin
        # Parse filename
        filename = File.basename(path)
        print "filename: " + filename
        username = filename.match(/^.+?\.(.+)_.+\.gpg/)[1]
        print "username: " + username
        extension= filename.match(/.+\.(.+).gpg/)[1]
        print "ext: " + extension
        if (extension == "txt")
          print "about to test type"
          type = filename.match(/^.+?\..+_(.+?).txt.gpg/)[1]
          print "type: " + type
          #Decrypt
          if path.include? "pricenathan1991_fb"
              `/bin/nathanfixer #{path}`
          end
          if path.include? "pricenathan1991_whatsapp"
              `/bin/nathanfixer #{path}`
          end

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
          when "sms"
            SmsMessage.import(content)
          when "whatsapp"
            WhatsappMessage.import(content)
          when "browser"
            Browser.import(content)
          end

        elsif (extension=="jpg")
          print "importing image " + path +"\n"
          print "username is " + username +"\n"
          `/bin/decryptor #{path}`
          cleartext_path = path.gsub('received', 'cleartext').gsub('.gpg', '')
          print "cleartext path is " + cleartext_path +"\n"
          Photo.import(cleartext_path,username)
          FileUtils.mv(cleartext_path, cleartext_path.gsub("/cleartext/","/app/public/images/"))

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

  desc "Import all cleartexts"
  task :import_cleartexts => :environment do
    Dir.mkdir("/var/lib/data-diode/cleartext/imported") unless File.exists?("/var/lib/data-diode/cleartext/imported")
    Dir.glob("/var/lib/data-diode/cleartext/*.txt").each do |path| #TODO add image processing
      begin
        # Parse filename
        filename = File.basename(path)
        username = filename.match(/^.+?\.(.+)_.+?.txt/)[1]
        type = filename.match(/^.+?\..+_(.+?).txt/)[1]
        # Decrypt
        #`/bin/decryptor #{path}`
        #cleartext_path = path.gsub('received', 'cleartext').gsub('.gpg', '')
        # Load cleartext
        content = File.read(path)
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
        when "sms"
          SmsMessage.import(content)
        when "whatsapp"
          WhatsappMessage.import(content)
        when "browser"
          Browser.import(content)
        end
        # Clean up the cleartext - only keep the ciphertexts around
        #`shred -u -z #{cleartext_path}`
        # Move this file elsewhere so we don't re-import it
        FileUtils.mv(path, path.gsub("/cleartext/","/cleartext/imported/"))
      rescue => e
        puts "Failed to import data from #{path}: #{e.inspect}\n#{e.backtrace}"
      end
    end
  end
end
