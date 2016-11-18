class UsersController < ApplicationController
  before_action :logged_in_user, only: 
[:index, :show, :edit, :update, :upload, :destroy,
 :iteration0, :iteration1, :iteration2, :iteration3, :iteration4, :poster, :first_video, :final_video,
 :final_report, :project, :filename]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:index, :destroy]

  def index
    #@users = User.order("lower(name) ASC").all.paginate(page: params[:page])
	#@users = User.order("lower(uin) ASC").all.paginate(page: params[:page])
	@sorting = params[:sort]
	    User.order( @sorting ? @sorting : :id).each do |mv|
            (@users ||= [ ]) << mv
		end
		@users = User.order(@sorting).all.paginate(page: params[:page])	
		@teams = {}
		
		@users.each do |user|
			res = Relationship.find_by_user_id(user.id)
			if res!=nil
			print(res.inspect)
				@teams[user.id] =  Team.find_by_id(res.team_id)
			else
				@teams[user.id]  = nil
			end
		end
print(@teams)
  end

  def show
		print("Params = " + params.to_s())
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
       log_in @user
       flash[:success] = "Welcome to the ProjectApp"
       redirect_to @user
    else
       render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

	def project

		@user = User.find(params[:user_id])
		@own = Own.find_by_user_id(params[:user_id])



		if !own?

			if !have_permission? 
				return 
			end
			@relationship = Relationship.find_by_user_id(params[:user_id])

			if !have_team?
				return
			end

			@team = Team.find(@relationship.team_id)
			@assignment = Assignment.find_by_team_id(@team.id)
		
			if !have_project?
				return
			end
			@project = Project.find(@assignment.project_id)


		else

		

			@project = Project.find(@own.project_id)
					

			@assignment = Assignment.find_by_project_id(@project.id)

			#print("Thi is an assignment")
			#print(@assignment)
			#print("\n\nBye\n\n")

			if !have_project?
				return
			end
			@team = Team.find(@assignment.team_id)
		end
	
		@member_ids = Relationship.where(team_id: @team.id).all
		@members = Array.new
		@member_ids.each do |member|
			tmp = User.find(member.user_id.to_i)
			@members << tmp.name.to_s
		end
	end

	def upload
		@user = User.find(params[:user_id])
		@own = Own.find_by_user_id(params[:user_id])

		if !current_user?(@user) 
			flash[:warning] = "You have no right"
			redirect_to current_user
			return
		end

		if !own?
			@relationship = Relationship.find_by_user_id(params[:user_id])
			@team = Team.find(@relationship.team_id)
			@assignment = Assignment.find_by_team_id(@team.id)
			@project = Project.find(@assignment.project_id)
		else
			@project = Project.find(@own.project_id)
			@assignment = Assignment.find_by_project_id(@project.id)
			@team = Team.find(@assignment.team_id)
		end
		

		iteration0 = params[:iteration0]
		iteration1 = params[:iteration1]
		iteration2 = params[:iteration2]
		iteration3 = params[:iteration3]
		iteration4 = params[:iteration4]
		poster = params[:poster]
		first_video = params[:first_video]
		final_video = params[:final_video]
		final_report = params[:final_report]

		if iteration0 != nil
			@project.iteration0 = iteration0.original_filename.to_s
			upload_file(iteration0)
		end
		if iteration1 != nil
			@project.iteration1 = iteration1.original_filename.to_s
			upload_file(iteration1)
		end
		if iteration2 != nil
			@project.iteration2 = iteration2.original_filename.to_s
			upload_file(iteration2)
		end
		if iteration3 != nil
			@project.iteration3 = iteration3.original_filename.to_s
			upload_file(iteration3)
		end
		if iteration4 != nil
			@project.iteration4 = iteration4.original_filename.to_s
			upload_file(iteration4)
		end
		if poster != nil
			@project.poster = poster.original_filename.to_s
			upload_file(poster)
		end
		if first_video != nil
			@project.first_video = first_video.original_filename.to_s
			upload_file(first_video)
		end
		if final_video != nil
			@project.final_video = final_video.original_filename.to_s
			upload_file(final_video)
		end
		if final_report != nil
			@project.final_report = final_report.original_filename.to_s
			upload_file(final_report)
		end
		@project.save
		
		redirect_to user_project_path(params[:user_id])
	end

	def download
		@user = User.find(params[:user_id])
		@own = Own.find_by_user_id(params[:user_id])

		if !current_user?(@user) 
			flash[:warning] = "You have no right"
			redirect_to current_user
			return
		end
		
		if !own?
			@relationship = Relationship.find_by_user_id(params[:user_id])
			if !have_team?
				return
			end
		else
			@project = Project.find(@own.project_id)
			@assignment = Assignment.find_by_project_id(@project.id)
			@relationship = Relationship.find_by_team_id(@assignment.team_id)
		end
		
		@team = Team.find(@relationship.team_id)
		filename = params[:filename]
		send_file("./public/uploads/"+@team.id.to_s+"/"+filename.to_s, :filename => filename.to_s, :type => "application/pdf")
	end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

	def make_admin
		@user = User.find(params[:user_id])

		if(!@user.admin)
			@user.update_attribute(:admin, true)
			flash[:success]  = @user.name  + " is now an Administrator!"
		
		else
			@user.update_attribute(:admin, false)
			flash[:success]  = "This administrator has been removed"
		
		end

		
		redirect_to @user
	end


	def update_project
		@relationship = Relationship.find_by_user_id(params[:user_id])
		@team = Team.find(@relationship.team_id)
		@assignment = Assignment.find_by_team_id(@team.id)
		@project = Project.find(@assignment.project_id)
		@project.iteration0 = params[:project][:iteration0]
		@project.iteration1 = params[:project][:iteration1]
		@project.iteration2 = params[:project][:iteration2]
		@project.iteration3 = params[:project][:iteration3]
		@project.iteration4 = params[:project][:iteration4]
		@project.first_video = params[:project][:first_video]
		@project.final_video = params[:project][:final_video]
		@project.final_report = params[:project][:final_report]
		@project.poster = params[:project][:poster]		
		@project.source_code = params[:project][:source_code]	
		@project.save	
		flash[:success] = "Successfully updated"
		redirect_to user_project_path(params[:user_id])
	end

	def admin_download
		admin_user
		
		@user = User.find(params[:user_id])
		@relationship = Relationship.find_by_user_id(params[:user_id])
		team_id = @relationship.team_id
		cmd = "tar czf ./public/uploads/"+team_id.to_s+".tar.gz"+" ./public/uploads/"+team_id.to_s
		system(cmd)
		send_file("./public/uploads/"+team_id.to_s+".tar.gz", :filename => team_id.to_s+".tar.gz", :type => "application/x-tar")
	end

  def destroy
    User.find(params[:id]).destroy 
    flash[:success] = "User Deleted Permanently!"
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name,:uin, :email, :password,
                                   :password_confirmation, :semester,:year, :course)
    end
end
