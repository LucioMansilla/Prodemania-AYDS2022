# frozen_string_literal: true

# Module for admin helper
module AdminHelper
  # Method admin_menu, returns the admin menu for the admin panel
  def menu_admin
    erb :"/admin/admin_menu", layout: :layout2
  end
end
