

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_Unsigned.all;
use work.hdlc_package.all;

entity HDLC_TRANSMIT is
  port (
    -- Global Reset
    Reset          : in  std_logic; -- Master reset

    -- HDLC Transmit Serial Interface
    TxC            : in  std_logic; -- Transmit Serial Clock
    TxD            : out std_logic; -- Transmit Serial Data

    -- HDLC Transmit External Memory Interface
    TxInputData_B0 : in  std_logic; -- Transmit Data Input Bit 0
    TxInputData_B1 : in  std_logic; -- Transmit Data Input Bit 1
    TxInputData_B2 : in  std_logic; -- Transmit Data Input Bit 2
    TxInputData_B3 : in  std_logic; -- Transmit Data Input Bit 3
    TxInputData_B4 : in  std_logic; -- Transmit Data Input Bit 4
    TxInputData_B5 : in  std_logic; -- Transmit Data Input Bit 5
    TxInputData_B6 : in  std_logic; -- Transmit Data Input Bit 6
    TxInputData_B7 : in  std_logic; -- Transmit Data Input Bit 7
    TxRead_n       : out std_logic; -- Transmit Data Read
    TxEmpty_n      : in  std_logic; -- Transmit Data Empty

    TxStart        : in  std_logic; -- Transmit Start
    TxAbort        : in  std_logic; -- Transmit Abort

    TxEnable       : in  std_logic  -- Transmit Enable
  );
end HDLC_TRANSMIT;

architecture HDLC_TRANSMIT_a of HDLC_TRANSMIT is

  -- State Machine Type Definition
  type F_INSERT_state_Typ is (FI0, FI1, FI2, FI3, FI4, FI5, FI6, FI7, NF);
  type Z_STUFF_state_Typ is (ZS0, ZS1, ZS2, ZS3, ZS4, ZS5, Stuff);

  -- F_INSERT Signal Declaration
  signal FI_State : F_INSERT_state_Typ;

  -- Z_STUFF Signal Declaration
  signal ZS_State : Z_STUFF_state_Typ;
  signal ZS_Out : std_logic;

  -- T_BUFFER Signal Declaration
  signal T_BUFFER : std_logic_vector(7 downto 0);

  -- T_SHIFT Signal Declaration
  signal T_SHIFT : std_logic_vector(7 downto 0);

  -- CRC_GEN Signal Declaration
  signal ZS_In : std_logic;
  signal CRC_feedback : std_logic;
  signal FCS : std_logic_vector(FCS_size-1 downto 0);

  -- A_INSERT Signal Declaration
  signal AbortLatch : std_logic;
  signal Abort : std_logic;
  signal Aborting : std_logic;

  -- T_CONTROL Signal Declaration
  signal StartLatch : std_logic;
  signal Start : std_logic;
  signal StartAck : std_logic;
  signal Read_n : std_logic;
  signal RstZS : std_logic;
  signal Latch : std_logic;
  signal NonFlagFields : std_logic;
  signal NotLastByte : std_logic;
  signal NotLastByteD : std_logic;
  signal Load : std_logic;
  signal EnCrcGen : std_logic;
  signal CRC_CNT : std_logic_vector(2 downto 0);
  signal TS_CNT : std_logic_vector(2 downto 0);

  -- TxInputData_int Signal Declaration
  signal TxInputData_int : std_logic_vector(7 downto 0);

begin

  TxInputData_int <= TxInputData_B7 & TxInputData_B6 &
                     TxInputData_B5 & TxInputData_B4 &
                     TxInputData_B3 & TxInputData_B2 &
                     TxInputData_B1 & TxInputData_B0;

--------------------------------------------------------------------------------
-- F_INSERT
--------------------------------------------------------------------------------

  -- F_INSERT State Machine
  --          State Type : (FI0, FI1, FI2, FI3, FI4, FI5, FI6, FI7, NF);
  F_INSERT_FSM: process(TxC, Reset)
  begin
    if (Reset='1') then
      FI_State <= FI0;
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        case FI_State is
          when FI0 =>
            FI_State <= FI1;
          when FI1 =>
            FI_State <= FI2;
          when FI2 =>
            FI_State <= FI3;
          when FI3 =>
            FI_State <= FI4;
          when FI4 =>
            FI_State <= FI5;
          when FI5 =>
            FI_State <= FI6;
          when FI6 =>
            FI_State <= FI7;
          when FI7 =>
            if (NonFlagFields='0') then
              FI_State <= FI0;
            else
              FI_State <= NF;
            end if;
          when NF =>
            if (NonFlagFields='0') then
              FI_State <= FI0;
            end if;
          when others =>
            FI_State <= FI0;
        end case;
      end if;
    end if;
  end process F_INSERT_FSM;

  -- TxD
  TxD_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      TxD <= '1';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        case FI_State is
          when FI0 =>
            TxD <= '0';
          when FI7 =>
            TxD <= '0';
          when NF =>
            TxD <= ZS_Out or Aborting;
          when others =>
            TxD <= '1';
        end case;
      end if;
    end if;
  end process TxD_Proc;

--------------------------------------------------------------------------------
-- Z_STUFF
--------------------------------------------------------------------------------

  -- Z_STUFF State Machine
  --         State Type : (ZS0, ZS1, ZS2, ZS3, ZS4, ZS5, Stuff);
  Z_STUFF_FSM: process(TxC, RstZS)
  begin
    if (RstZS='1') then
      ZS_State <= ZS0;
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
          case ZS_State is
            when ZS0 =>
              if (ZS_In='1') then
                ZS_State <= ZS1;
              end if;
            when ZS1 =>
              if (ZS_In='1') then
                ZS_State <= ZS2;
              else
                ZS_State <= ZS0;
              end if;
            when ZS2 =>
              if (ZS_In='1') then
                ZS_State <= ZS3;
              else
                ZS_State <= ZS0;
              end if;
            when ZS3 =>
              if (ZS_In='1') then
                ZS_State <= ZS4;
              else
                ZS_State <= ZS0;
              end if;
            when ZS4 =>
              if (ZS_In='1') then
                ZS_State <= ZS5;
              else
                ZS_State <= ZS0;
              end if;
            when ZS5 =>
              ZS_State <= Stuff;
            when Stuff =>
              if (ZS_In='1') then
                ZS_State <= ZS1;
              else
                ZS_State <= ZS0;
              end if;
            when others =>
              ZS_State <= ZS0;
          end case;
      end if;
    end if;
  end process Z_STUFF_FSM;

  -- ZS_In
  ZS_In <= T_SHIFT(0) when (EnCrcGen='0') else
           not FCS(FCS_size-1);

  -- ZS_Out
  ZS_Out <= '1' when (ZS_State = ZS1) else
            '1' when (ZS_State = ZS2) else
            '1' when (ZS_State = ZS3) else
            '1' when (ZS_State = ZS4) else
            '1' when (ZS_State = ZS5) else
            '0';

--------------------------------------------------------------------------------
-- T_BUFFER
--------------------------------------------------------------------------------

  T_BUFFER_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      T_BUFFER <= (others => '0');
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (Latch='1') then
        T_BUFFER <= TxInputData_int(7 downto 0);
      end if;
    end if;
  end process T_BUFFER_Proc;

--------------------------------------------------------------------------------
-- T_SHIFT
--------------------------------------------------------------------------------

  T_SHIFT_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      T_SHIFT <= (others => '0');
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (ZS_State/=ZS5) then
        if (Load='1') then
          T_SHIFT <= T_BUFFER;
        else
          T_SHIFT <= '0' & T_SHIFT(7 downto 1);
        end if;
      end if;
    end if;
  end process T_SHIFT_Proc;

--------------------------------------------------------------------------------
-- CRC_GEN
--------------------------------------------------------------------------------

  -- CRC generation
  --
  CRC_feedback <= (FCS(FCS_size-1) xor T_SHIFT(0)) and not EnCrcGen;

  CRC_Proc: process (TxC, RstZS)
  begin
    if (RstZS='1') then
      FCS <= (others => '1');
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (ZS_State/=ZS5) then
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

--------------------------------------------------------------------------------
-- A_INSERT
--------------------------------------------------------------------------------

  -- AbortLatch
  AbortLatch_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      AbortLatch <= '0';
    elsif rising_edge(TxC) then
      if (Abort='1') then
        AbortLatch <= '0';
      elsif (TxAbort='1') then
        AbortLatch <= '1';
      end if;
    end if;
  end process AbortLatch_Proc;

  -- Abort
  Abort_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      Abort <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        Abort <= AbortLatch;
      end if;
    end if;
  end process Abort_Proc;

  -- Aborting
  Aborting_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      Aborting <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        if (NonFlagFields='0') then
          Aborting <= '0';
        elsif (Abort='1') then
          Aborting <= '1';
        end if;
      end if;
    end if;
  end process Aborting_Proc;

--------------------------------------------------------------------------------
-- T_CONTROL
--------------------------------------------------------------------------------

  -- StartLatch
  StartLatch_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      StartLatch <= '0';
    elsif rising_edge(TxC) then
      if (Start='1') or (NonFlagFields='1') then
        StartLatch <= '0';
      elsif (TxStart='1') then
        StartLatch <= '1';
      end if;
    end if;
  end process StartLatch_Proc;

  -- Start
  Start_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      Start <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        Start <= StartLatch;
      end if;
    end if;
  end process Start_Proc;

  -- StartAck
  StartAck_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      StartAck <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        if (NonFlagFields='1') then
          StartAck <= '0';
        elsif (Start='1') and (TxEmpty_n='1') then
          StartAck <= '1';
        end if;
      end if;
    end if;
  end process StartAck_Proc;

  -- Read_n
  Read_n_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      Read_n <= '1';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        if (StartAck='1') and (FI_State=FI3) then
          Read_n <= '0';
        elsif (ZS_State=ZS5) then
          Read_n <= '1';
        elsif (TS_CNT="101") and (NotLastByte='1') then
          Read_n <= '0';
        elsif (TS_CNT="101") and (NotLastByteD='1') then
          Read_n <= '0';
        else
          Read_n <= '1';
        end if;
      end if;
    end if;
  end process Read_n_Proc;

  -- TxRead_n
  TxRead_n_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      TxRead_n <= '1';
    elsif rising_edge(TxC) then
      if (TxEnable='0') then
        TxRead_n <= '1';
      elsif (StartAck='1') and (FI_State=FI3) then
        TxRead_n <= '0';
      elsif (ZS_State=ZS5) then
        TxRead_n <= '1';
      elsif (TS_CNT="101") and (NotLastByte='1') then
        TxRead_n <= '0';
      elsif (TS_CNT="101") and (NotLastByteD='1') then
        TxRead_n <= '0';
      else
        TxRead_n <= '1';
      end if;
    end if;
  end process TxRead_n_Proc;

  -- RstZS
  RstZS_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      RstZS <= '1';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        RstZS <= not NonFlagFields;
      end if;
    end if;
  end process RstZS_Proc;

  -- Latch
  Latch_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      Latch <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        Latch <= not Read_n;
      end if;
    end if;
  end process Latch_Proc;

  -- CRC_CNT
  CRC_CNT_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      CRC_CNT <= (others => '0');
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (ZS_State/=ZS5) then
        if (EnCrcGen='0') then
          CRC_CNT <= (others => '0');
        elsif (TS_CNT="111") then
          CRC_CNT <= CRC_CNT + 1;
        end if;
      end if;
    end if;
  end process CRC_CNT_Proc;

  -- NonFlagFields
  NonFlagFields_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      NonFlagFields <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (ZS_State/=ZS5) then
        if (Aborting='1') and (TS_CNT="111") then
          NonFlagFields <= '0';
        elsif (FCS_size=16) and (CRC_CNT(1)='1') then
          NonFlagFields <= '0';
        elsif (FCS_size=32) and (CRC_CNT(2)='1') then
          NonFlagFields <= '0';
        elsif (Latch='1') then
          NonFlagFields <= '1';
        end if;
      end if;
    end if;
  end process NonFlagFields_Proc;

  -- NotLastByte
  NotLastByte_Proc: process (TxC, FI_State)
  begin
    if (FI_State=FI0) then
      NotLastByte <= '1';
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (Latch='1') then
        NotLastByte <= TxEmpty_n;
      end if;
    end if;
  end process NotLastByte_Proc;

  -- NotLastByteD
  NotLastByteD_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      NotLastByteD <= '1';
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (ZS_State/=ZS5) and (Load='1') then
        NotLastByteD <= NotLastByte;
      end if;
    end if;
  end process NotLastByteD_Proc;

  -- Load
  Load <= '0' when (NotLastByte = '0') and (NotLastByteD = '0') else
          '0' when (TS_CNT /= "000") else
          '1';

  -- TS_CNT
  TS_CNT_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      TS_CNT <= (others => '0');
    elsif rising_edge(TxC) then
      if (TxEnable='1') then
        if (Abort='1') or (NonFlagFields='0') then
          TS_CNT <= (others => '0');
        elsif (Aborting='1') or (ZS_State/=ZS5) then
          TS_CNT <= TS_CNT + 1;
        end if;
      end if;
    end if;
  end process TS_CNT_Proc;

  -- EnCrcGen
  EnCrcGen_Proc: process (TxC, Reset)
  begin
    if (Reset='1') then
      EnCrcGen <= '0';
    elsif rising_edge(TxC) then
      if (TxEnable='1') and (ZS_State/=ZS5) then
        if (FI_State=FI7) or (Aborting='1') then
          EnCrcGen <= '0';
        elsif (NonFlagFields='1') and (NotLastByte='0') and (NotLastByteD='0')
              and (TS_CNT="000") then
          EnCrcGen <= '1';
        end if;
      end if;
    end if;
  end process EnCrcGen_Proc;

end HDLC_TRANSMIT_a;

