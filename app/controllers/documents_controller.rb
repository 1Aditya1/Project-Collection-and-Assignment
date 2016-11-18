class DocumentsController < ApplicationController
  def index
  end

  def new
  end

  def create
    print("\n\n\n Helloo")
    print(params)
    print("Byeee \n\n\n")

    #Write code to save into db here
    # create_table "documents", force: :cascade do |t|
    #  t.boolean  "is_legacy"
    # t.boolean  "is_file"
    #t.string   "name"
    #t.string   "doc_type"
    #t.integer  "project_id"
    #t.datetime "date"
    #t.string   "author"
    #t.string   "link"
    #t.string   "filein"
  file_stats = [false, false, true, true]
  param_names = [:link1, :link2, :filein1, :filein2]
  doc_types = [:github_link, :heroku_link, :final_report, :final_poster]
  
  (0..3).each do |i|

  d = Document.new
  d.is_legacy = true
  d.is_file = file_stats[i]
  d.author =  params[:document][:author]
  d.project_id = params[:curr_project]
  d.doc_type = doc_types[i]

  if(param_names[i].to_s.include?("link"))  
  d.link = params[:document][param_names[i]]

  else
  d.filein = params[:document][param_names[i]]
  end
  d.save!
  end #end do

 # d2.link = params[:document][:link2]
 # d3.filein = params[:document][:file1]
 # d4.filein = params[:document][:file2]


  #print(u.filein.url )# => '/url/to/file.png'
  #print(u.filein.current_path) # => 'path/to/file.png'
  #print(u.filein_identifier) # => 'file.png'

    @p = Project.find(params[:curr_project])


    flash[:success] = "Legacy Record Added"
    redirect_to project_legacy_path(@p)


  end

  def destroy
  end
end
