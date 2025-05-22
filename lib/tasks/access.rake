namespace :access do
  desc 'Shows access tree'
  task tree: [:environment]  do
    puts Access.tree_str
  end
  task test: [:environment]  do |t, args|
    ARGV.shift
    resource, label, role, user = ARGV.map{ |x| eval x}
    if user
      Access.user = user
      puts Access.user.inspect
    end
    unless resource.is_a?(Class) || resource.is_a?(Symbol)
      puts resource.inspect
      if user
        puts "is_self? = #{user.is_self? resource}"
      end
    end
    puts "Access.allow? %s, %s, %s" % ARGV
    puts Access.allow?(resource, label, role)
    exit
  end
end
