class CreaturesController < ApplicationController
  before_action :locate_creature, only: [:show, :edit, :update]

  def index
    @creature_list = Creature.all
  end

  def new
    @creature = Creature.new
    @tags = Tag.all
  end

  def edit
    @creature = Creature.find(params[:id])
    @tags = Tag.all
  end

  def create
    # render json: params
    @creature = Creature.create(creatures_params)

    # if @creature.save
    #   flash[:success] = "Your creature has been added"
    #   @creature.tags.clear
    #   tags = params[:creature][:tag_ids]
    #   tags.each do |tag_id|
    #     @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    #   end
    #   redirect_to creatures_path
    # else
    #   @tags = Tag.all
    #   render 'new'
    # end

    if @creature.save(creatures_params)
      @creature.tags.clear
      tags = params[:creature][:tag_ids].split(",")
      tags.each do |name|
        @creature.tags << Tag.find_or_create_by({name: name}) unless name.blank?
      end
      redirect_to creatures_path
    else
      render 'edit'
    end
  end

  def update
    @creature = Creature.find_by_id(params[:id])

    # if @creature.update(creatures_params)
    #   @creature.tags.clear
    #   tags = params[:creature][:tag_ids]
    #   tags.each do |tag_id|
    #     @creature.tags << Tag.find(tag_id) unless tag_id.blank?
    #   end
    #   redirect_to creatures_path
    # else
    #   render 'edit'
    # end

    if @creature.update(creatures_params)
      @creature.tags.clear
      tags = params[:creature][:tag_ids].split(",")
      tags.each do |name|
        @creature.tags << Tag.find_or_create_by({name: name}) unless name.blank?
      end
      redirect_to creatures_path
    else
      render 'edit'
    end

  end

  def show
    @creature = Creature.find_by_id(params[:id])

    list = flickr.photos.search :text => @creature.name, :sort => "relevance"

    @results = list.map do |photo|
      FlickRaw.url_s(photo)
    end
  end

  def destroy
    @creature = Creature.find(params[:id])
    @creature.destroy

    redirect_to creatures_path
  end

  def tag
    tag = Tag.find_by_name(params[:tag])
      @creatures = tag ? tag.creatures : []
  end

  # def tags
  #   @creatures = Creature.all

  #   @tags = Tag.select("tags.*,count(creatures.id) AS creature_count").joins(:creatures).group("tags.id").order("creature_count DESC").limit(15)
  # end

private

  def creatures_params
    params.require(:creature).permit(:name,:desc)
  end

  def locate_creature
    not_found unless @creature = Creature.find_by_id(params[:id])
      # redirect_to '/404.html'
    # end
  end

end