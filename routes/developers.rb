class Developers < Cuba
  define do
    on "dashboard" do
      render("developer_dashboard", title: "Developer dashboard")
    end

    on default do
      render("developer_dashboard", title: "Developer dashboard")
    end
  end
end