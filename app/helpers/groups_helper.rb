module GroupsHelper
  def is_admin(options = {})
    options[:user] = current_user if options[:user].blank?
    options[:group] = @group if options[:group].blank?
    options[:group].admins.include? options[:user]
  end

  def is_member(options = {})
    options[:user] = current_user if options[:user].blank?
    options[:group] = @group if options[:group].blank?
    options[:group].members.include? options[:user]
  end
end
