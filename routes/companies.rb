class Companies < Cuba
  define do
    on "dashboard" do
      res.write "Welcome to your company dashboard!"
    end

    on default do
      res.write "/dashboard"
    end
  end
end