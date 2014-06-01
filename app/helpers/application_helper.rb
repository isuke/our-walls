module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title="")
    base_title = "Our Walls"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def signed_in_user
    unless signed_in?
      flash[:warning] = "Please sign in."
      redirect_to signin_url
    end
  end
end
