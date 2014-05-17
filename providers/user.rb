def whyrun_supported?
	false
end

use_inline_resources

action :create do
	converge_by "Create user #{@new_resource.name}" do
		save_user(@new_resource)
	end
end

def load_current_resource
	users = ::IO.readlines(users_file).
			map { |i| i.strip }.
			find_all { |i| not i.empty? }.
			find_all { |i| not i.start_with?('#') }.
			map { |line| build_user(line) }
end

private
def users_file
	::File.join(node['fuseesb']['install_dir'], 'etc', 'users.properties')
end

def build_user(line)
	elements = line.split(/[=,]/)

	user = Chef::Resource::FuseesbUser.new(elements[0])
	user.password(elements[1])
	user.roles(elements[2..-1])

	user
end

def save_user(user)
	lines = ::IO.readlines(users_file)

	edited = false

	modified = lines.map do |line|
		if line.start_with?("#{user.name}=") then
			edited = true
			user.as_string
		else
			line.strip
		end
	end

	unless edited then
		modified << user.as_string
	end

	::File.write(users_file, modified.join("\n"))
end
