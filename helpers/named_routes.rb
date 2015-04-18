module NamedRoutes
  def root_path
    @root_path ||= "/".freeze
  end

  def new_session_path
    @new_session_path ||= File.join(root_path, "login").freeze
  end
end