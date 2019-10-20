module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      warning: 'alert-warning',
      error: 'alert-error',
      alert: 'alert-block',
      notice: 'alert-info'
    }[flash_type.to_sym]
  end

  def foundation_class_for(flash_type)
    {
      success: 'success',
      warning: 'warning',
      error: 'alert',
      alert: 'alert',
      notice: 'primary'
    }[flash_type.to_sym]
  end
end
