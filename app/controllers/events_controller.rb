# frozen_string_literal: true

class EventsController < ApplicationController
  def index
    @q = Event.future.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(created_at: :desc).page(params[:page])
  end

  def future
    @q = Event.future.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(held_at: :asc).page(params[:page])
    @search_path = future_events_path
    render :index
  end

  def past
    @q = Event.past.ransack(params[:q])
    @events = @q.result(distinct: true).includes(:bookmarks, :prefecture, user: { avatar_attachment: :blob })
                .order(held_at: :desc).page(params[:page])
    @search_path = past_events_path
    render :index
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.only_woman? && !current_user.woman?
      redirect_to new_event_path, alert: '女性限定イベントを作成する権限がありません。'
    elsif @event.save
      User.all.find_each do |user|
        NotificationFacade.created_event(@event, user)
      end
      redirect_to event_path(@event), notice: 'イベントを作成しました。'
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    if @event.only_woman? && !current_user&.woman?
      redirect_to events_path, alert: 'このイベントは女性限定です。'
    else
      @can_join = !@event.only_woman? || (current_user&.woman? && @event.only_woman?)
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])
    if @event.only_woman? && !current_user.woman?
      redirect_to edit_event_path(@event), alert: '女性限定イベントを更新する権限がありません。'
    elsif @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :content, :held_at, :prefecture_id, :thumbnail, :only_woman)
  end
end
