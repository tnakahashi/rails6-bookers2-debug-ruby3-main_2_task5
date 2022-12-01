class BooksController < ApplicationController
  
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @new_book = Book.new
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = User.find(@book.user_id)
  end

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index, notice: "You have not created book successfully."
    end
  end

  def edit
    @book = Book.find(params[:id])
    user_id = @book.user_id
    login_user_id = current_user.id
    if(user_id != login_user_id)
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
