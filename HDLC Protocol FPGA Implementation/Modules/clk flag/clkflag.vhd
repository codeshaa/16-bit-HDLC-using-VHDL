----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:31:52 11/27/2013 
-- Design Name: 
-- Module Name:    clkflag - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clkflag is
port(clk,a,reset:in std_logic;
     cko:inout std_logic;
	  y:out std_logic);
end clkflag;

architecture Behavioral of clkflag is
component clkdiv is
 port( clk_in: in std_logic;
       reset : in std_logic;
		 clk_1hz :out  std_logic);
		 
end component;

component flagen is
port(clk,a:in std_logic;
     z:out std_logic);
end component;

begin
ck: clkdiv port map(clk,reset,cko);
flg: flagen port map(cko,a,y);


end Behavioral;

