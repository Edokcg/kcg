--ライフ·ストリーム·ドラゴン
function c169.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,aux.FilterBoolFunction(Card.IsCode,2403771),1,1)
	c:EnableReviveLimit()

	--change lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25165047,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c169.lpcon)
	e1:SetOperation(c169.lpop)
	c:RegisterEffect(e1)

	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c169.damval)
	c:RegisterEffect(e2)

	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26082117,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	--e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c169.tg)
	e3:SetOperation(c169.op)
	c:RegisterEffect(e3)
end
c169.listed_names={2403771}

function c169.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO 
	  and (Duel.GetLP(tp)<2000 or Duel.GetLP(1-tp)<2000)
end
function c169.lpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)<2000 then Duel.SetLP(tp,2000) end
	if Duel.GetLP(1-tp)<2000 then Duel.SetLP(1-tp,2000) end
end
function c169.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end

function c169.eqfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsType(TYPE_SYNCHRO)
end
function c169.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c169.eqfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(c169.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	  local g=Duel.SelectTarget(tp,c169.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	  local tc=g:GetFirst()
	  local t={}
	local i=1
	local p=1
	local lv=tc:GetLevel()
	for i=1,12 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26082117,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c169.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
