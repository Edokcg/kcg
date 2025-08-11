--常闇之空 (K)
function c337.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1735088,2))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c337.tg)
	e2:SetOperation(c337.op)
	c:RegisterEffect(e2)
end

function c337.filter(g,tp)
	local c=g:GetFirst()
	if c:IsControler(1-tp) then c=g:GetNext() end
	if c then return c end
	return nil
end
function c337.filter2(c)
	return c:IsFaceup()
end
function c337.filter3(c)
	return c:IsCode(330)
end
function c337.filter32(c)
	return c:IsCode(331)
end

function c337.desfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c337.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chkc then return chkc:IsLocation(LOCATION_MZONE) and c337.filter2(chkc) end
	local g=Duel.GetMatchingGroup(c337.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local rc=eg:Filter(c337.desfilter,nil,tp)
	if chk==0 then 
		--local rc=c337.filter(eg,tp)
		return rc:GetCount()>0 and g:GetCount()>0 end
end
function c337.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:Filter(c337.desfilter,nil,tp)
	local ag=Duel.GetMatchingGroup(c337.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e) and rc:GetCount()>0 and ag:GetCount()>0 then
	  local rccount=rc:GetCount()
	  for i=1,rccount do
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	  local g1=rc:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c337.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Overlay(g2:GetFirst(),g1) 
	  end end
end
function c337.condition2(e,tp,eg,ep,ev,re,r,rp) 
	  local tc=e:GetLabelObject()
	  local code=e:GetLabel()
	return tc:GetOverlayGroup():FilterCount(Card.IsCode,nil,code)>0
end
