--次元融合杀
local s,id=GetID()
function s.initial_effect(c)
	--特殊召唤混沌幻魔
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	-- e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	-- e1:SetType(EFFECT_TYPE_ACTIVATE)
	-- e1:SetCode(EVENT_FREE_CHAIN)
	-- e1:SetTarget(s.target)
	-- e1:SetOperation(s.activate)
	-- c:RegisterEffect(e1)
	
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x145),extrafil=s.fextra,chkf=FUSPROC_NOTFUSION|FUSPROC_LISTEDMATS,stage2=s.stage2,extraop=Fusion.BanishMaterial})
	local tg=e1:GetTarget()
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						return tg(e,tp,eg,ep,ev,re,r,rp,chk)
					end
					tg(e,tp,eg,ep,ev,re,r,rp,chk)
					-- if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,6007213,32491822,69890967),tp,LOCATION_MZONE,0,1,nil)
					-- 	and e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler()==e:GetOwner() then
						Duel.SetChainLimit(s.chlimit)
					--end
				end)
	c:RegisterEffect(e1)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
s.listed_series={0x145}
s.listed_names={6007213,32491822,69890967}

function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	end
end
function s.stage2(e,tc,tp,mg,chk)
	if chk==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
-- -------------------------------------------------------------------------------------------------------------------------------------------
-- function s.tffilter(c)
-- 	local code=c:GetCode()
-- 	return c:IsAbleToRemove()
-- 	and (code==32491822 or code==69890967 or code==6007213)
-- end

-- function s.tfilter(c,e,tp)
-- 	return c:IsCode(43378048) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
-- end

-- function s.filter(c,code)
-- 	return c:IsCode(code) and c:IsAbleToRemove()
-- end

-- function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
-- 	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,6007213)
-- 	 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,32491822)
-- 	 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,69890967)
-- 	 and Duel.IsExistingMatchingCard(s.tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
-- 	Duel.SetChainLimit(s.chlimit)
-- end
-- function s.chlimit(e, ep, tp)
--     return tp == ep
-- end

-- function s.activate(e,tp,eg,ep,ev,re,r,rp)
-- 	local sg=Duel.GetMatchingGroup(s.tffilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
-- 	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
-- 	local g1=sg:Select(tp,1,1,nil)
-- 	sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
-- 	local ft=2
-- 	local g2=nil
-- 	while ft>0 do
-- 		g2=sg:Select(tp,1,1,nil)
-- 		g1:Merge(g2)
-- 		sg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
-- 		ft=ft-1
-- 	end
-- 	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
-- 	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
-- 	local sg=Duel.SelectMatchingCard(tp,s.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
-- 	if sg:GetCount()>0 then
-- 		Duel.BreakEffect()
-- 		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
-- 		local tc=sg:GetFirst()
-- 	end
-- end