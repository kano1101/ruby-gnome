# Copyright (C) 2017  Ruby-GNOME2 Project Team
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

module WebKit2Gtk
  class WebView
    unless private_method_defined?(:initialize_new_with_related_view)
      class << self
        def new(*args)
          return super unless args.size == 1
          return super unless args[0].is_a?(Hash)

          related_view = args[0][:related_view]
          return super unless related_view
          related_view.new_with_related_view
        end
      end
    end

    alias_method :initialize_raw, :initialize
    def initialize(*args)
      case args.size
      when 1
        case args[0]
        when Hash
          initialize_with_hash(args[0])
        when WebContext
          message = "#{caller[0]}: #{self.class}.new(context) is deprecated. "
          message << "Use #{self.class}.new(:context => context) instead."
          warn(message)
          initialize_raw(args[0])
        else
          raise ArgumentError, "must be options: #{args[0].inspect}"
        end
      else
        initialize_raw(*args)
      end
    end

    def initialize_with_hash(options)
      context = options[:context]
      settings = options[:settings]
      user_content_manager = options[:user_content_manager]
      related_view = options[:related_view]

      if context
        initialize_new_with_context(context)
      elsif settings
        initialize_new_with_settings(settings)
      elsif user_content_manager
        initialize_new_with_user_content_manager(user_content_manager)
      elsif related_view
        initialize_new_with_related_view(related_view)
      else
        message =
          "must specify :context, :settings, :user_content_manager or :related_view"
        raise ArgumentError, message
      end
    end
    private :initialize_with_hash
  end
end
