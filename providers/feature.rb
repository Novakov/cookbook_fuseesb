include Chef::Mixin::ShellOut

def whyrun_supported?
	false
end

action :install do
	converge_by "Installing feature #{@new_resource.name}" do
		shell_out!("c:\\fuseesb\\bin\\client.bat -h localhost -u admin -p admin features:install #{@new_resource.name}")
	end
end
