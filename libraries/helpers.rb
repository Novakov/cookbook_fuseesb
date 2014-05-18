::Chef::Resource::RubyBlock.send(:include, Windows::Helper)

require 'net/ssh'

def extract_fuse_esb(source, dest_path)
	require 'zip'
	Zip::File.open(cached_file(source, '')) do |zip|
		zip.each do |entry|
	      	 	entry_name = Pathname(entry.name).each_filename.drop(1).to_a.join("/")
	
			path = ::File.join(dest_path, entry_name)
	
	      		FileUtils.mkdir_p(::File.dirname(path))
	
	      		zip.extract(entry, path)
	    	end
	end    
end

def find_java_home
	if not node['fuseesb']['java_home'].nil? then
		return node['fuseesb']['java_home']
	end

	javaPath = nil
	['Java Runtime Environment', 'Java Development Kit'].each do |java_kind|
		begin
			::Win32::Registry::HKEY_LOCAL_MACHINE.open("SOFTWARE\\JavaSoft\\#{java_kind}\\1.7", 256 | ::Win32::Registry::KEY_READ) do |reg|		
				javaPath = reg['JavaHome']
			end
		rescue
		end
	end

	if javaPath.nil? then
		Chef::Application.fatal!('Unable to find Java7 home')
	end

	return javaPath
end

def execute_karaf_command(command)
	::Net::SSH.start('localhost', node['fuseesb']['admin_user'], :password => node['fuseesb']['admin_password'], :port => node['fuseesb']['ssh_port']) do |ssh|
		ssh.exec!(command) do |channel, stream, data|
			Chef::Log.info("FuseESB #{stream} #{data}")
		end
	end
end
