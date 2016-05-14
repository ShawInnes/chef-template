# chef-template

Chef 'generate' templates

## Usage

```
git clone https://github.com/ShawInnes/chef-template ~/chef-template
chef generate cookbook test1 -g ~/chef-template
```

~/.chef/knife.rb
```
chefdk.generator_cookbook "~/chef-template"
```
