--精灵兽 迪尔邦多
local s, id = GetID()
function s.initial_effect(c)
	--不能成为对方的卡的效果对象
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetValue(s.tgvalue)
	--c:RegisterEffect(e1)
	
	--1回合1次不被战斗破坏
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	--e2:SetCountLimit(1)
	--e2:SetValue(s.valcon)
	--c:RegisterEffect(e2)
	
	--战斗破坏对方怪兽加一半攻击
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCondition(aux.bdogcon)
	e3:SetOperation(s.upop)
	c:RegisterEffect(e3)
	
	--有场地存在时不能把这张卡作为攻击对象
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetCondition(s.atkcon)
	e5:SetValue(Auxiliary.imval1)
	c:RegisterEffect(e5)
end
---------------------------------------------------------------------------------------------
function s.rafilter3(c,e,tp)
	return c:GetOriginalCode()==900000099 and not c:IsImmuneToEffect(e)
			 and Duel.IsExistingTarget(s.rafilter4,tp,LOCATION_MZONE,0,1,c,e)
end
function s.rafilter4(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function s.ratg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.rafilter3(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.rafilter3,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.rafilter3,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
end
function s.raop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	  local g2=Duel.SelectTarget(tp,s.rafilter4,tp,LOCATION_MZONE,0,1,20,tc,e)
	  local gc=g2:GetFirst()
	  local tatk=0
	  while gc do
	  local atk=tc:GetAttack()
	  if atk<0 then atk=0 end
	  tatk=tatk+atk
	  local code=gc:GetOriginalCode()
	  tc:CopyEffect(code,0,0)
	  gc=g2:GetNext() end
	  Duel.SendtoGrave(g2,REASON_EFFECT)
	if tc then
	local e0=Effect.CreateEffect(tc)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	  e0:SetValue(tatk)
	tc:RegisterEffect(e0)
	end
end

----------------------------------------------
function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------------------------------------------
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
------------------------------------------------------------------------------------------------------------
function s.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local bc=c:GetBattleTarget()
    if not bc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(bc:GetAttack()/2)
	c:RegisterEffect(e1)
    c:CopyEffect(bc:GetOriginalCode(), RESET_EVENT+0x1fe0000, 1)
end
---------------------------------------------------------------------------------------------------------
function s.atkcon(e)
	local tc=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	if tc and tc:IsFaceup() then return true end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return tc and tc:IsFaceup()
end
