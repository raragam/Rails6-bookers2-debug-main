class Book < ApplicationRecord

  validates :title,presence:true
  validates :body,presence:true
  validates :body, length: { minimum: 1, maximum: 200 }



  scope :created_today, -> { where(created_at: Time.current.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }



  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user

  has_many :book_comments, dependent: :destroy

  has_many :view_counts, dependent: :destroy



  is_impressionable counter_cache: true



  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end



  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
