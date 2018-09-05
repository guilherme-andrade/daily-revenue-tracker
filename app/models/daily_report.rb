class DailyReport < ApplicationRecord
  belongs_to :user
  before_create :calculate_kreditkarte_total, unless: :store?
  before_create :calculate_cash_revenues, unless: :store?

  validates_presence_of :summe_treuekarte, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :summe_rechnung, :on => :create, :message => "can't be blank"
  validates_presence_of :summe_rabatte, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :summe_gutschein, :on => :create, :message => "can't be blank"
  validates_presence_of :summe_lunchchecks, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :summe_einkauf, :on => :create, :message => "can't be blank"
  validates_presence_of :maestro, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :mastercard, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :visa, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :andere, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :lunch_umsatz, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :dinner_umsatz, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :lunch_anzahl_personen, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :dinner_anzahl_personen, :on => :create, :message => "can't be blank", unless: :store?
  validates_presence_of :gutschein_nummer, :on => :create, :message => "can't be blank"

  def store?
    self.business == 'store'
  end

  def summe_umsatz
    self.lunch_umsatz + self.dinner_umsatz
  end

  def total_not_cash
    self.summe_treuekarte + self.summe_rechnung + self.summe_rabatte + self.summe_gutschein + self.summe_lunchchecks + self.kreditkarte_total + self.summe_einkauf
  end

  def calculate_cash_revenues
    self.bar = self.summe_umsatz - total_not_cash
  end

  def calculate_kreditkarte_total
    self.kreditkarte_total = self.mastercard + self.visa + self.maestro + self.andere
  end

  def to_column
    [[self.user.username, self.date, self.lunch_anzahl_personen, self.lunch_umsatz, self.dinner_anzahl_personen, self.dinner_umsatz, self.bar, self.mastercard, self.visa, self.maestro, self.andere, self.kreditkarte_total, self.summe_treuekarte, self.summe_rechnung, self.summe_rabatte, self.summe_lunchchecks, self.summe_einkauf, self.gutschein_nummer, self.summe_gutschein, self.summe_umsatz]]
  end

  def to_store_column
    [[self.user.username, self.date, self.kreditkarte_total, self.summe_rechnung, self.gutschein_nummer, self.summe_gutschein, self.summe_einkauf, self.total_umsatz]]
  end
end
