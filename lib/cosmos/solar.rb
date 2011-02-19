module Cosmos
  class Solar

    attr_accessor :date, :lat, :lng

    def initialize(attrs={})
      attrs.each_pair do |key, value|
        self.send("#{key.to_s}=", value)
      end
    end

    class << self

      # Julian cycle since Jan 1, 2000
      def julian_cycle(julian_date, lng) # n
        ( julian_date.to_f - JAN_1_2000 - 0.0009 - (lng / 360) ).round
      end

      def mean_anomaly(noon) # M
        equation = Proc.new{|tran| ( 357.5291 + 0.98560028 * (tran - JAN_1_2000) ).modulo(360) }
        m = equation.call noon
        # recursively calculate mean_anomaly using the noon until it stops changing
        10.times do
          c     = self.equation_of_center(m)
          lam   = self.ecliptic_longitude(m, c)
          jtran = self.noon(noon, m, lam)
          m2    = equation.call jtran
          break if m == m2
          m = m2
        end
        m
      end

      def equation_of_center(mean_anomaly) # C
        (1.9148 * sin(mean_anomaly)) + (0.0200 * sin(2 * mean_anomaly)) + (0.0003 * sin(3 * mean_anomaly))
      end

      def ecliptic_longitude(mean_anomaly, equation_of_center) # λ lambda
        (mean_anomaly + 102.9372 + equation_of_center + 180).modulo(360)
      end

      def noon(noon_approximation, mean_anomaly, ecliptic_longitude) # Jnoon as Julian Date
        noon_approximation + (0.0053 * sin(mean_anomaly)) - (0.0069 * sin(2 * ecliptic_longitude))
      end

      def declination(ecliptic_longitude) # δ delta as degrees
        asin( sin(ecliptic_longitude) * sin(23.45) )
      end

      # At high latitudes this will sometimes be 0.
      # This means that either the sun does not rise (in the winter) or the sun does not set (in the summer) on that day.
      def hour_angle(lat, declination) # H -or- ω omega as degrees
        acos( (sin(-0.83) - sin(lat) * sin(declination)) / (cos(lat) * cos(declination)) )
      end

      def noon_approximation(julian_cycle, lng, hour_angle=0) # J* and J** as Julian Date
        JAN_1_2000 + 0.0009 + ((lng + hour_angle)/360) + julian_cycle
      end

      def set(noon, mean_anomaly, ecliptic_longitude) # sunset as Julian Date
        noon + (0.0053 * sin(mean_anomaly)) - (0.0069 * sin(2 * ecliptic_longitude))
      end

      def rise(noon, set) # sunrise as Julian Date
        noon - (set - noon)
      end

    protected

      # Solar equations use degrees, not radians
      def acos(degrees)
        Math.acos(degrees) * RADS_PER_DEG
      end
      def asin(degrees)
        Math.asin(degrees) * RADS_PER_DEG
      end
      def sin(degrees)
        Math.sin(degrees / RADS_PER_DEG)
      end
      def cos(degrees)
        Math.cos(degrees / RADS_PER_DEG)
      end

    end

    # Julian cycle since Jan 1, 2000
    def julian_cycle # n
      Solar.julian_cycle(self.date.jd, self.lng)
    end

    def noon_approximation # J*
      DateTime.new! self.noon_approximation_jd
    end

    def mean_anomaly # M
      Solar.mean_anomaly(self.noon_approximation_jd)
    end

    def equation_of_center # C
      Solar.equation_of_center(self.mean_anomaly)
    end

    def ecliptic_longitude # λ lambda
      Solar.ecliptic_longitude(self.mean_anomaly, self.equation_of_center)
    end

    def noon # Jnoon
      DateTime.new! self.noon_jd
    end

    def declination # δ delta
      Solar.declination(self.ecliptic_longitude)
    end

    def hour_angle # H -or- ω omega
      Solar.hour_angle(self.lat, self.declination)
    end

    def set
      DateTime.new! self.set_jd
    end

    def rise
      DateTime.new! self.rise_jd
    end

   protected

    def noon_approximation_jd
      Solar.noon_approximation(self.julian_cycle, self.lng)
    end

    def noon_jd
      Solar.noon(self.noon_approximation_jd, self.mean_anomaly, self.ecliptic_longitude)
    end

    def set_jd
      j2 = Solar.noon_approximation(self.julian_cycle, self.lng, self.hour_angle) # J**
      Solar.set(j2, self.mean_anomaly, self.ecliptic_longitude)
    end

    def rise_jd
      Solar.rise(self.noon_jd, self.set_jd)
    end

  end
end

