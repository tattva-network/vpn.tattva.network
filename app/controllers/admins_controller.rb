class AdminsController < ApplicationController
    before_action :authenticate_admin!

    def index
        @admin = current_admin
    end

    def show 
        @users = User.all
    end

    def user_activate
        users = User.where(id: params[:id], account_status: "inactive").exists?(conditions = :none)
        name = User.where(id: params[:id]).pluck(:email)
        name = name[0].split('@')[0]

        if users
            User.update(params[:id], account_status: "active")
            add_ovpn_user = `/bin/sh /root/vpn.tattva.network/vpn.tattva.network/script.sh add #{name}`
            puts add_ovpn_user
        else
            User.update(params[:id], account_status: "inactive")
            remove_ovpn_user = `/bin/sh /root/vpn.tattva.network/vpn.tattva.network/script.sh remove #{name}`
            puts remove_ovpn_user
        end

        redirect_to admins_show_path
    end
end
