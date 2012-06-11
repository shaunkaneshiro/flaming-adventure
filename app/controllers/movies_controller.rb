class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if session[:sort_col]
      puts "session[:sort_col]=" + session[:sort_col] + "."
    end
    if params[:sort_col]
      puts "params[:sort_col]=" + params[:sort_col] + "."
    end

    # determine which column to sort by
    user_sort_col = params[:sort_col]
    if ((user_sort_col == "title")||(user_sort_col == "release_date")) then
      @sort_col = user_sort_col
      puts "@sort_col from params"
    else
      if session[:sort_col]
        @sort_col = session[:sort_col]
        puts "@sort_col from session"
        redirect_to movies_path :sort_col => @sort_col
      end
      if !@sort_col
        @sort_col = "title"
        puts "@sort_col from default"
      end
    end

    @all_ratings = Movie.all_ratings_method
    @user_selected_ratings = (params[:ratings])
    if (@user_selected_ratings) then
      selected_ratings = params[:ratings].keys
    else
      @user_selected_ratings = { }
      selected_ratings = @all_ratings
    end

    session[:sort_col] = @sort_col
    session[:user_selected_ratings] = @user_selected_ratings

    @movies = Movie.find(:all, :order => @sort_col + " ASC", :conditions => [ "rating IN (?)", selected_ratings] )
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
