class TagsController < ApplicationController

  def index
    # @tags = Tag.all
    @creatures = Creature.all

    @tags = Tag.select("tags.*,count(creatures.id) AS creature_count").joins(:creatures).group("tags.id").order("creature_count DESC").limit(15)

  end

  # def new
  #   @tag = Tag.new
  #   @tags = Tag.all
  # end

  # def edit
  #   @tag = Tag.find(params[:id])
  # end

  # def create

  #   if @tag = Tag.create(tags_params)
  #     redirect_to tags_path
  #   else
  #     render 'edit'
  #   end
  # end

  # def update
  #   @tag = Tag.find_by_id(params[:id])
  #   if @tag.update(tags_params)
  #     redirect_to tags_path
  #   else
  #     render 'edit'
  #   end
  # end

  # private

  # def tags_params
  #   params.require(:tag).permit(:name)
  # end

end