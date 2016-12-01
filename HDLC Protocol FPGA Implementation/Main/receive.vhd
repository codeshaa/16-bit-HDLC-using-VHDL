-----------------------------------------------------------------------------------------
---------------------------------Receive Module------------------------------------------
-----------------------------------------------------------------------------------------
  
library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_Unsigned.all;
use work.hdlc_package.all;

entity HDLC_RECEIVE is
  port (
    -- Global Reset
    Reset  : in  std_logic; -- Master reset

    -- HDLC Receive Serial Interface
    RxC : in  std_logic; -- Receive Serial Clock
    RxD : in  std_logic; -- Receive Serial Data

    -- HDLC Receive External Memory Interface
    RxOutputData_B0  : out std_logic; -- Receive Data Output Bit 0
    RxOutputData_B1  : out std_logic; -- Receive Data Output Bit 1
    RxOutputData_B2  : out std_logic; -- Receive Data Output Bit 2
    RxOutputData_B3  : out std_logic; -- Receive Data Output Bit 3
    RxOutputData_B4  : out std_logic; -- Receive Data Output Bit 4
    RxOutputData_B5  : out std_logic; -- Receive Data Output Bit 5
    RxOutputData_B6  : out std_logic; -- Receive Data Output Bit 6
    RxOutputData_B7  : out std_logic; -- Receive Data Output Bit 7
    RxDataWrite_n   : out std_logic; -- Receive Data Valid
    RxStatusWrite_n : out std_logic;  -- Receive Status Valid

    RxEnable        : in  std_logic  -- Receive Enable
  );
end HDLC_RECEIVE;

architecture HDLC_RECEIVE_a of HDLC_RECEIVE is

  -- Function CRC_Remainder
  function CRC_Remainder(numBits: in integer) return std_logic_vector is
    variable R    : std_logic_vector(numBits-1 downto 0);
    variable feedback : std_logic;
  begin
    R := (others => '1');
    for i in 0 to numBits-1 loop
      feedback := R(numBits-1);
      for j in numBits-1 downto 1 loop
        if (CRC_Polynomial(j) = '1') then
          R(j) := R(j-1) xor feedback;
        else
          R(j) := R(j-1);
        end if;
      end loop;
      R(0) := feedback;
    end loop;
    return R;
  end function CRC_Remainder;

  -- State Machine Type Definition
  type F_DETECT_state_Typ is (FD0, FD1, FD2, FD3, FD4, FD5, FD6, Flag, Idle);
  type Z_UNSTUFF_state_Typ is (ZU0, ZU1, ZU2, ZU3, ZU4, ZU5, Unstuff);

  -- CRC_CHK Signal Declaration
  signal CRC_feedback : std_logic;
  signal FCS : std_logic_vector(FCS_size-1 downto 0);
  signal CRC_err : std_logic;
  --HD 230410 add sample signal
  signal CRC_err_sample : std_logic;

  -- F_DETECT Signal Declaration
  signal F_State : F_DETECT_state_Typ;
  signal FDT : std_logic;
  signal OctetDetected : std_logic;
  signal OD_CNT : std_logic_vector(3 downto 0);
  signal RstStatus : std_logic;

  -- Z_UNSTUFF Signal Declaration
  signal Z_State : Z_UNSTUFF_state_Typ;
  signal EnShift : std_logic;

  -- A_DETECT Signal Declaration
  signal Abort : std_logic;
  --HD 230410 add sample signal
  signal Abort_sample : std_logic;

  -- BIT_CNT Signal Declaration
  signal BIT_CNT : std_logic_vector(2 downto 0);
  signal Octet_err : std_logic;
  --HD 230410 add sample signal
  signal Octet_err_sample : std_logic;


  -- R_BUFFER Signal Declaration
  signal R_BUFFER : std_logic_vector(7 downto 0);

  -- R_SHIFT Signal Declaration
  signal R_SHIFT : std_logic_vector(7 downto 0);

  -- R_CONTROL Signal Declaration
  signal DataValid : std_logic;
  signal StatusValid : std_logic_vector(6 downto 0);
  signal OctetDetectedD : std_logic;

  -- RxOutputData_int Signal Declaration
  signal RxOutputData_int : std_logic_vector(7 downto 0);

  -- Attributes for ispMACH5000VG to get higher performance
  --   These can be removed when the UART design is targeted to other devices.
--  ATTRIBUTE SYN_KEEP : integer;
--  ATTRIBUTE SYN_KEEP OF BIT_CNT : SIGNAL IS 1;
--  ATTRIBUTE OPT : string;
--  ATTRIBUTE OPT OF BIT_CNT : SIGNAL IS "KEEP";

begin

  RxOutputData_B0 <= RxOutputData_int(0);
  RxOutputData_B1 <= RxOutputData_int(1);
  RxOutputData_B2 <= RxOutputData_int(2);
  RxOutputData_B3 <= RxOutputData_int(3);
  RxOutputData_B4 <= RxOutputData_int(4);
  RxOutputData_B5 <= RxOutputData_int(5);
  RxOutputData_B6 <= RxOutputData_int(6);
  RxOutputData_B7 <= RxOutputData_int(7);

--------------------------------------------------------------------------------
-- F_DETECT
--------------------------------------------------------------------------------

  -- F_DETECT State Machine
  --          State Type : (FD0, FD1, FD2, FD3, FD4, FD5, FD6, Flag, Idle);
  F_DETECT_FSM: process(RxC, Reset)
  begin
    if (Reset='1') then
      F_State <= FD0;
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        case F_State is
          when FD0 =>
            if (RxD='1') then
              F_State <= FD1;
            end if;
          when FD1 =>
            if (RxD='1') then
              F_State <= FD2;
            else
              F_State <= FD0;
            end if;
          when FD2 =>
            if (RxD='1') then
              F_State <= FD3;
            else
              F_State <= FD0;
            end if;
          when FD3 =>
            if (RxD='1') then
              F_State <= FD4;
            else
              F_State <= FD0;
            end if;
          when FD4 =>
            if (RxD='1') then
              F_State <= FD5;
            else
              F_State <= FD0;
            end if;
          when FD5 =>
            if (RxD='1') then
              F_State <= FD6;
            else
              F_State <= FD0;
            end if;
          when FD6 =>
            if (RxD='1') then
              F_State <= Idle;
            else
              F_State <= Flag;
            end if;
          when Flag =>
            if (RxD='1') then
              F_State <= FD1;
            else
              F_State <= FD0;
            end if;
          when Idle =>
            if (RxD='0') then
              F_State <= FD0;
            end if;
          when others =>
            F_State <= FD0;
        end case;
      end if;
    end if;
  end process F_DETECT_FSM;

  -- FDT : will be '1' when Flag is detected
  --     : will be '0' when the first Octet is received
  FDT_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      FDT <= '0';
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (OctetDetected='1') then
          FDT <= '0';
        elsif (F_State=FD6) and (RxD='1') then
          FDT <= '0';
        elsif (F_State=Flag) then
          FDT <= '1';
        end if;
      end if;
    end if;
  end process FDT_Proc;

  -- OctetDetected : will be '1' when the first Octet is received
  --               : will be '0' when six consecutive 1's are received
  OctetDetected <= OD_CNT(3);

  OD_CNT_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      OD_CNT <= (others => '0');
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (F_State=FD6) then
          OD_CNT <= (others => '0');
        elsif (F_State=Flag) or (FDT='1') then
          OD_CNT <= OD_CNT + 1;
        end if;
      end if;
    end if;
  end process OD_CNT_Proc;

  -- RstStatus : will be '1' one clock before OctetDetected turnes high
  --           : used to reset "Abort" and initialize "FCS"
  RstStatus <= '1' when (Reset='1') else
               '1' when (OD_CNT=B"0111") and (FDT='1') and (F_State/=FD6) else
               '0';

--------------------------------------------------------------------------------
-- Z_UNSTUFF
--------------------------------------------------------------------------------

  -- Z_UNSTUFF State Machine
  --           State Type : (ZU0, ZU1, ZU2, ZU3, ZU4, ZU5, Unstuff);
  Z_UNSTUFF_FSM: process(RxC, OctetDetected)
  begin
    if (OctetDetected='0') then
      Z_State <= ZU0;
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        case Z_State is
          when ZU0 =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU1;
            end if;
          when ZU1 =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU2;
            else
              Z_State <= ZU0;
            end if;
          when ZU2 =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU3;
            else
              Z_State <= ZU0;
            end if;
          when ZU3 =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU4;
            else
              Z_State <= ZU0;
            end if;
          when ZU4 =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU5;
            else
              Z_State <= ZU0;
            end if;
          when ZU5 =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU0;
            else
              Z_State <= Unstuff;
            end if;
          when Unstuff =>
            if (R_BUFFER(0)='1') then
              Z_State <= ZU1;
            else
              Z_State <= ZU0;
            end if;
          when others =>
            Z_State <= ZU0;
        end case;
      end if;
    end if;
  end process Z_UNSTUFF_FSM;

  -- EnShift : will be '1' during the (data + FCS) transition period
  --           except the zero unstuffing clock
  EnShift <= '0' when (Z_State = ZU5) and (R_BUFFER(0) = '0') else
              OctetDetected;

--------------------------------------------------------------------------------
-- A_DETECT
--------------------------------------------------------------------------------

  -- Abort : will be '1' when seven or more consecutive 1's are received
  --       : will be '0' when Flag is detected
  Abort_Proc: process (RxC, RstStatus)
  begin
    if (RstStatus='1') then
      Abort <= '0';
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (F_State=Flag) then
          Abort <= '0';
        elsif (F_State=FD6) then
          Abort <= OctetDetected and RxD;
        end if;
      end if;
    end if;
  end process Abort_Proc;

--------------------------------------------------------------------------------
-- BIT_CNT
--------------------------------------------------------------------------------

  -- Octet_err : will be '1' when receiving a non-integer number of Octets
  --           : will be '0' when Flag is detected
  Octet_err <= BIT_CNT(0) or BIT_CNT(1) or BIT_CNT(2);

  BIT_CNT_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      BIT_CNT <= (others => '0');
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (F_State=Flag) or (Abort='1') then
          BIT_CNT <= (others => '0');
        elsif (EnShift='1') then
          BIT_CNT <= BIT_CNT + 1;
        end if;
      end if;
--      if (F_State=Flag) or (Abort='1') then
--        BIT_CNT <= (others => '0');
--      elsif (RxEnable='1') and (EnShift='1') then
--        BIT_CNT <= BIT_CNT + 1;
--      end if;
    end if;
  end process BIT_CNT_Proc;

--------------------------------------------------------------------------------
-- CRC_CHK
--------------------------------------------------------------------------------

  -- CRC checking
  --
  CRC_feedback <= FCS(FCS_size-1) xor R_BUFFER(0);

  CRC_Proc: process (RxC, RstStatus)
  begin
    if (RstStatus='1') then
      FCS <= (others => '1');
    elsif rising_edge(RxC) then
      if (RxEnable='1') and (EnShift='1') then
        for i in FCS_size-1 downto 1 loop
          if (CRC_Polynomial(i) = '1') then
            FCS(i) <= FCS(i-1) xor CRC_feedback;
          else
            FCS(i) <= FCS(i-1);
          end if;
        end loop;
        FCS(0) <= CRC_feedback;
      end if;
    end if;
  end process CRC_Proc;

  -- CRC_err
  CRC_err_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      CRC_err <= '0';
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (FCS = CRC_Remainder(FCS_size)) then
          CRC_err <= '0';
        else
          CRC_err <= '1';
        end if;
      end if;
    end if;
  end process CRC_err_Proc;

--------------------------------------------------------------------------------
-- R_BUFFER
--------------------------------------------------------------------------------

  R_BUFFER_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      R_BUFFER <= (others => '0');
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        R_BUFFER <= RxD & R_BUFFER(7 downto 1);
      end if;
    end if;
  end process R_BUFFER_Proc;

--------------------------------------------------------------------------------
-- R_SHIFT
--------------------------------------------------------------------------------

  R_SHIFT_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      R_SHIFT <= (others => '0');
    elsif rising_edge(RxC) then
      if (RxEnable='1') and (EnShift='1') then
        R_SHIFT <= R_BUFFER(0) & R_SHIFT(7 downto 1);
      end if;
    end if;
  end process R_SHIFT_Proc;

--------------------------------------------------------------------------------
-- R_CONTROL
--------------------------------------------------------------------------------

  -- DataValid
  DataValid_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      DataValid <= '0';
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (Z_State = ZU5) and (R_BUFFER(0) = '0') then
          DataValid <= '0';
        elsif (BIT_CNT="111") then
          DataValid <= '1';
        else
          DataValid <= '0';
        end if;
      end if;
    end if;
  end process DataValid_Proc;

  -- RxDataWrite_n
  RxDataWrite_n_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      RxDataWrite_n <= '1';
    elsif rising_edge(RxC) then
      RxDataWrite_n <= not (RxEnable and DataValid and not Abort);
    end if;
  end process RxDataWrite_n_Proc;

  -- OctetDetectedD
  OctetDetectedD_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      OctetDetectedD <= '0';
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        OctetDetectedD <= OctetDetected;
      end if;
    end if;
  end process OctetDetectedD_Proc;

  -- StatusValid
  StatusValid_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      StatusValid <= (others => '0');
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        StatusValid(0) <= OctetDetectedD and not OctetDetected;
        for i in 1 to 6 loop
          StatusValid(i) <= StatusValid(i-1);
        end loop;
      end if;
    end if;
  end process StatusValid_Proc;

  -- RxStatusWrite_n
  RxStatusWrite_n_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      RxStatusWrite_n <= '1';
    elsif rising_edge(RxC) then
      RxStatusWrite_n <= not (RxEnable and StatusValid(6));
    end if;
  end process RxStatusWrite_n_Proc;

--------------------------------------------------------------------------------
-- R_DATA
--------------------------------------------------------------------------------

-- Added new process RXOUTPUTSAMPLE_PROC
--Since the output of the Abort, Octet_err and CRC_err is delayed by 7 clock cycles
--we need to sample the values at the right point.

  RxOutputsample_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
		Abort_sample <= '0'; 
		Octet_err_sample <='0';  
		CRC_err_sample <= '0';
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (Statusvalid(0)='1') then
			Abort_sample <= Abort; 
			Octet_err_sample <=Octet_err;  
			CRC_err_sample <= CRC_err;
        
		else
			Abort_sample <= Abort_sample; 
			Octet_err_sample <=Octet_err_sample;  
			CRC_err_sample <= CRC_err_sample;
        end if;
      end if;
    end if;
  end process RxOutputsample_Proc;


-- Modified RXOutputData_proc to use the sample Error signals
  RxOutputData_Proc: process (RxC, Reset)
  begin
    if (Reset='1') then
      RxOutputData_int <= (others => '0');
    elsif rising_edge(RxC) then
      if (RxEnable='1') then
        if (DataValid='1') then
          RxOutputData_int <= R_SHIFT;
        elsif (StatusValid(6)='1') then
--HD          RxOutputData_int <= "11111" & Abort & Octet_err & CRC_err;
              RxOutputData_int <= "11111" & Abort_Sample & Octet_err_sample & CRC_err_sample;
        end if;
      end if;
    end if;
  end process RxOutputData_Proc;

end HDLC_RECEIVE_a;

