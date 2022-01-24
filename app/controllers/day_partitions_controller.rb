class DayPartitionsController < ApplicationController
  before_action :set_day_partition, only: %i[edit update destroy]

  def index
    @day_partitions = current_user.day_partitions.not_defaults.ordered_by_position
  end

  def new
    @form = DayPartitionForm.new(current_user.day_partitions.new)
  end

  def create
    @form = DayPartitionForm.new(current_user.day_partitions.new, day_partition_params)

    if @form.save
      redirect_to day_partitions_path, notice: 'Day partition added'
    else
      flash[:notice] = 'Invalid input'
      render :new
    end
  end

  def edit
    @form = DayPartitionForm.new(@day_partition)
  end

  def update
    @form = DayPartitionForm.new(@day_partition, day_partition_params)

    if @form.save
      redirect_to day_partitions_path, notice: 'Day partition updated'
    else
      flash[:notice] = 'Invalid input'
      render :edit
    end
  end

  def destroy
    DayPartitionForm.new(@day_partition).destroy
    redirect_to day_partitions_path, notice: 'Day partition deleted'
  end

  private

  def day_partition_params
    params.require(:day_partition).permit(:name, :position)
  end

  def set_day_partition
    @day_partition = current_user.day_partitions.not_defaults.find(params[:id])
  end
end
