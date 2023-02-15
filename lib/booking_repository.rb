# create booking moeid
# remove booking when it's done
# should interact with spaces to remove booked spaces
# only makers should be able to confirm bookings
# user should be able to book spaces
# user should be able to see their booking requests
# user and maker should be able to see their confirmed requests
require_relative "./booking"

class BookingRepository

	def all
		sql = "SELECT * FROM bookings;"
    result_set = DatabaseConnection.exec_params(sql, [])
    bookings = []
		result_set.each do |record|
      booking = Bookings.new
      booking.id = record["id"].to_i
      booking.confirmed = record["confirmed"]
      booking.requested_space_id = record["requested_space_id"].to_i
      booking.requested_user_id = record["requested_user_id"].to_i
      bookings << booking
    end
    return bookings

	end

	def create(booking) #moeid
		sql = "INSERT INTO bookings (confirmed, requested_space_id, requested_user_id) VALUES('#{booking.confirmed}', '#{booking.requested_space_id}', '#{booking.requested_user_id}');"
    result_set = DatabaseConnection.exec_params(sql, [])
    return result_set
  end
	
	
	def find_by_booking_id(id) #terry
    sql = "SELECT id, confirmed, requested_space_id, requested_user_id FROM bookings WHERE id = $1;"
    result = DatabaseConnection.exec_params(sql, [id])[0]
    
    booking = Bookings.new
    booking.id = result['id'].to_i
    booking.confirmed = result['confirmed']
    booking.requested_space_id = result['requested_space_id'].to_i
    booking.requested_user_id = result['requested_user_id'].to_i
    
    return booking
	end

	# def delete(id)

	# end

	def confirm(id)#maker -chris
    sql = 'UPDATE bookings SET confirmed=TRUE WHERE id = $1;'
    result = DatabaseConnection.exec_params(sql, [id])

    return
	end

	def find_by_space_id(space_id) #dora
    sql = "SELECT id, confirmed, requested_space_id, requested_user_id FROM bookings WHERE requested_space_id = $1;"
    result = DatabaseConnection.exec_params(sql, [space_id])[0]
    
    booking = Bookings.new
    booking.id = result['id'].to_i
    booking.confirmed = result['confirmed']
    booking.requested_space_id = result['requested_space_id'].to_i
    booking.requested_user_id = result['requested_user_id'].to_i
    return booking
	end

	def find_by_user_id(user_id) #Dora
    sql = "SELECT id, confirmed, requested_space_id, requested_user_id FROM bookings WHERE requested_user_id = $1;"
    result = DatabaseConnection.exec_params(sql, [user_id])[0]
    
    booking = Bookings.new
    booking.id = result['id'].to_i
    booking.confirmed = result['confirmed']
    booking.requested_space_id = result['requested_space_id'].to_i
    booking.requested_user_id = result['requested_user_id'].to_i
    
    return booking
	end

end