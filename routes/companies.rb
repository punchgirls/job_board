class Companies < Cuba
  define do
    on "dashboard" do
      render("company_dashboard", title: "Company dashboard")
    end

    on "post_job_offer" do
      on post, param("post") do |params|
        post_job_offer = PostJobOffer.new(params)

        if post_job_offer.valid?
          params[:company_id] = Company[session["Company"]].id
          post = Post.create(params)

          session[:success] = "You have successfully posted a job offer!"
          res.redirect "/dashboard"
        else
          session[:error] = "All fields are required"
          render("post_job_offer", title: "Post job offer")
        end
      end

      on default do
        render("post_job_offer", title: "Post job offer")
      end
    end

    on "remove_post/:id" do |id|
      Post[id].delete
      session[:success] = "Post successfully removed!"
      render("company_dashboard", title: "Company dashboard")
    end

    on "jobs" do
      render("jobs", title: "Jobs")
    end

    on "logout" do
      logout(Company)
      session[:success] = "You have successfully logged out!"
      render("home", title: "Home")
    end

    on default do
      render("company_dashboard", title: "Company dashboard")
    end
  end
end