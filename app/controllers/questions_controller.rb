class QuestionsController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :show]
	def index
		@questions = Question.all
		@random = @questions.shuffle
		render 'index'
	end

	def show
		@question = Question.find params[:id]
	end

	def new
		@question = Question.new
	end

	def create
		@question = Question.new question_params
		if @question.save
			redirect_to action: 'index', controller: 'questions', id: @question.id
		else
			render 'new'
		end
	end

	def update
		@question = Question.find params[:id]
		authorize @question
		if @question.update_attributes question_params
			redirect_to action: 'index', controller: 'questions'
		else
			@errors = question.errors.full_messages
			render 'edit'
		end
	end

	private

	def question_params
		params.require(:question).permit(:question, :answer)
	end
end
