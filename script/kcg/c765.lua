--Darkness 逆轉命運 (KA)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_series={0x316}
s.listed_names={511310104,511310105}

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function s.ofilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function s.darkness(c)
	return c:IsFaceup() and c:GetFlagEffect(id)~=0 and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS) and c:IsSetCard(0x316)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)==0 then return end
	if Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12744567,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=Duel.SelectMatchingCard(tp,s.ofilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
		if og and not og:IsImmuneToEffect(e) then
			Duel.Overlay(e:GetHandler(),og)
		end
	end
	local g=Duel.GetMatchingGroup(s.darkness,tp,LOCATION_SZONE,0,e:GetHandler())
	if g:GetCount()>0 then
		while g:GetCount()>0 do
			local tc=g:GetFirst()
			s.zero(e:GetHandler(),tp)
			g:RemoveCard(tc)
		end
	end
end

function s.zero(tc,tep)
	local te=tc:GetActivateEffect()
	if te==nil or tc:CheckActivateEffect(true,false,false)==nil then return end
	local condition=te:GetCondition()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	Duel.ClearTargetCard()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
	tc:CreateEffectRelation(te)
	local gg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if gg then  
		local etc=gg:GetFirst()	
		while etc do
			etc:CreateEffectRelation(te)
			etc=gg:GetNext()
		end
	end						
	if operation then 
		if Duel.IsExistingMatchingCard(s.ofilter,tep,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tep,aux.Stringid(12744567,0)) then
			Duel.Hint(HINT_SELECTMSG,tep,HINTMSG_XMATERIAL)
			local og=Duel.SelectMatchingCard(tep,s.ofilter,tep,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
			if og and not og:IsImmuneToEffect(te) then
				Duel.Overlay(tc,og)
			end
		end
	end
	tc:ReleaseEffectRelation(te)					
	if gg then  
		local etc=gg:GetFirst()												 
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=gg:GetNext()
		end
	end 
end