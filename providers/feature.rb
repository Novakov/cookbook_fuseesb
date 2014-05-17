include Chef::Mixin::ShellOut

def whyrun_supported?
	false
end

action :install do
	converge_by "Installing feature #{@new_resource.name}" do
		execute_karaf_command("features:install #{@new_resource.name}")
	end
end


action :uninstall do
	converge_by "Uninstalling feature #{@new_resource.name}" do
		execute_karaf_command("features:uninstall #{@new_resource.name}")
	end
end
