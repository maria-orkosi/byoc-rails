class PagesController < ActionController::API
  # GET /api/landing_page
  def landing_page
    render json: {
      company_name: "Byoc Rails",
      tagline: "Byoc Rails runs on Orkosi from its own code",
      description: "Byoc Rails is the repository maria-orkosi/byoc-rails, brought to Orkosi as it is and run from its own code: every part detected, placed and deployed without a remake.",
      audience: "saas",
      features: [
        {
          title: "Auto-Detection",
          description: "Every part of your repository is detected automatically when you bring it to Orkosi."
        },
        {
          title: "Deploy from Your Own Code",
          description: "Your repository runs directly from its own code on Orkosi. No rewrites, no platform lock-in."
        },
        {
          title: "Seamless Placement",
          description: "Your code is placed and deployed on infrastructure that matches your stack."
        },
        {
          title: "Full Operations",
          description: "Monitoring, logging, scaling, and zero-downtime deployments are built in."
        },
        {
          title: "Built-In Reliability",
          description: "Every deployment gets health checks, automatic restarts, and isolated environments."
        },
        {
          title: "Rapid Time-to-Value",
          description: "Bring your repo and go live in minutes, not weeks."
        }
      ]
    }
  end
end