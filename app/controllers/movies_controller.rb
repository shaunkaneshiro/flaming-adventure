class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if (!params[:sort_col])&&session[:sort_col]
      @sort_col = session[:sort_col]
      if session[:ratings]
        @user_selected_ratings= eval session[:ratings]
      end
      flash.keep
      redirect_to movies_path :sort_col => @sort_col, :ratings => @user_selected_ratings
    end

    # determine which column to sort by
    user_sort_col = params[:sort_col]
    if ((user_sort_col == "title")||(user_sort_col == "release_date")) then
      @sort_col = user_sort_col
    else
      @sort_col = "title"
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
    session[:ratings] = @user_selected_ratings.to_s

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
