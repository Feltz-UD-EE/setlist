#
# Copyright 2025 John C. Feltz, github: Feltz-UD-EE/setlist
#
# Static routes
#
class StaticController < ApplicationController
    def public_home
        @bands = signed_in? ? current_user.bands.alpha : Band.none
    end

    def about
    end

    def credits
    end

    def legal
    end
end
