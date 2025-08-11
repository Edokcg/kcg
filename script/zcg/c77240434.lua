--原始昆虫 甲虫蜥蜴兽(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.srtg)
	e2:SetOperation(s.srop)
	c:RegisterEffect(e2)
--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(s.efilter)
	c:RegisterEffect(e11)
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_MZONE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,2,2,nil)
	if g:GetCount()>0 then
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do 
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function s.efilter(e,te)
	local c=e:GetHandler()
	local ec=te:GetHandler()
	if ec:IsHasCardTarget(c) then return true end
	return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te) and ec:GetControler()~=c:GetControler()
end
