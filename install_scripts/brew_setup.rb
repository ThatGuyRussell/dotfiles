require "#{File.dirname __FILE__}/user_ask"

def brew_installed?
  `command -v brew &> /dev/null`
  $?.success?
end

def install_brew()
  unless brew_installed?
    if user_ask :default_confirm, "Would you like to install homebrew?"
      `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install)"`
      `export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH`
      puts 'Homebrew was installed.'.green
    else
      puts "Homebrew was not installed."
      return
    end
  else
    puts 'Homebrew is already installed.'.green
  end
  puts
  if user_ask :default_confirm, 'Would you like to install your Homebrew default packages now?'
    `brew bundle --global`
  else
    puts 'Run `brew bundle --global` when you want to install default packages.'.yellow
  end
  puts '(Any cask apps that are already installed without cask must first be uninstalled)'.yellow
end
