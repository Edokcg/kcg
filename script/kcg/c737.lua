local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)	
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.tactivate)
	c:RegisterEffect(e1)
end
s.listed_series={0x316}
s.listed_names={511310104,511310105}

function s.darkness(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsSetCard(0x316)
	and c:GetOverlayCount()>0
end
function s.ofilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end	
	if chk==0 then return true end
	if Duel.IsExistingTarget(s.darkness,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():GetFlagEffect(id)~=0 then		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.darkness,tp,LOCATION_ONFIELD,0,1,1,nil)
	end
end
function s.tactivate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)==0 then return end
	local sc=Duel.GetFirstTarget()
	if not sc or sc:IsFacedown() or not sc:IsRelateToEffect(e) or sc:IsControler(1-tp) or sc:IsImmuneToEffect(e) then return end
	local og2=sc:GetOverlayGroup():Filter(s.ofilter,nil)
	if og2:GetCount()<1 then return end
	for tc in aux.Next(og2) do
		s.zero(tc,e,tp)
	end	
end

function s.zero(tc,e,tep)
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
	if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if gg then  
		local etc=gg:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=gg:GetNext()
		end
	end 
end
