
context = ChefDK::Generator.context
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

# cookbook root dir
directory cookbook_dir

# metadata.rb
template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# README
template "#{cookbook_dir}/VERSION" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# README
template "#{cookbook_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

if context.use_berkshelf

  # Berks
  cookbook_file "#{cookbook_dir}/Berksfile" do
    action :create_if_missing
  end
else

  # Policyfile
  template "#{cookbook_dir}/Policyfile.rb" do
    source "Policyfile.rb.erb"
    helpers(ChefDK::Generator::TemplateHelper)
  end

end


# TK & Inspec
template "#{cookbook_dir}/.kitchen.yml" do
  if context.use_berkshelf
    source 'kitchen.yml.erb'
  else
    source 'kitchen_policyfile.yml.erb'
  end

  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

directory "#{cookbook_dir}/test/integration/default/inspec" do
  recursive true
end

template "#{cookbook_dir}/test/integration/default/inspec/default.rb" do
  source 'inspec_default.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Attributes

directory "#{cookbook_dir}/attributes"

template "#{cookbook_dir}/attributes/default.rb" do
  source "attribute.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes

directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source "recipe.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# git
if context.have_git
  if !context.skip_git_init

    execute("initialize-git") do
      command("git init .")
      cwd cookbook_dir
    end
  end

  cookbook_file "#{cookbook_dir}/.gitignore" do
    source "gitignore"
  end
end
