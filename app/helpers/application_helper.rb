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

  def pronoun_or_name_for(user, pronoun='You')
    if current_user?(user)
      pronoun
    else
      user.name
    end
  end

end
