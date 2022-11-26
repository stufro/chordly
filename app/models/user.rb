class User < ApplicationRecord
  include Flipper::Identifier

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  has_many :chord_sheets, dependent: :destroy
  has_many :set_lists, dependent: :destroy
end
