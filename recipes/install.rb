attrib = node['fuseesb']

java_home = find_java_home

ruby_block 'Unzip FuseESB' do
	block do		
		extract_fuse_esb attrib['source_archive'], attrib['install_dir']
	end

	not_if {::File.exists?(::File.join(attrib['install_dir'], 'bin', 'karaf.bat')) }
end


template ::File.join(attrib['install_dir'], 'bin', 'setenv.bat') do
	source 'setenv.bat.erb'

	sensitive true

	variables :java_home=> java_home,
		  :karaf_home => attrib['install_dir']

	action :create
end

batch 'Register Karaf service' do
	cwd attrib['install_dir']

	code <<EOF
@echo off

cd bin

move ..\\etc\\shell.init.script ..\\etc\\shell.init.script.bak

echo features:install wrapper 	> ..\\etc\\shell.init.script
echo wrapper:install 	 	>> ..\\etc\\shell.init.script
echo osgi:shutdown -f 		>> ..\\etc\\shell.init.script

call karaf.bat

move ..\\etc\\shell.init.script.bak ..\\etc\\shell.init.script

call karaf-service.bat install

EOF
	not_if { ::Win32::Service.exists?('karaf') }
end

service 'karaf' do
	action :start
end
